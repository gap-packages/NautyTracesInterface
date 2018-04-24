/*
 * NautyTracesInterface: An interface to nauty
 */

#include "src/compiled.h"          /* GAP headers */
#include <nauty.h>
#include <naugroup.h>
#include <nautinv.h>
#include "nausparse.h"
#include <gtools.h>


static Obj automorphism_list;
Obj TheTypeNautyInternalGraphObject;
UInt T_NAUTY_OBJ = 0;

Obj NautyObjCopyFunc(Obj obj, Int mut)
{
    return obj;
}

void NautyObjCleanFunc(Obj obj)
{
}

Int NautyObjIsMutableFunc(Obj obj)
{
    return 0L;
}

Obj NautyObjTypeFunc(Obj o)
{
    return TheTypeNautyInternalGraphObject;
}

#define IS_NAUTY_GRAPH_OBJ(o) (TNUM_OBJ(o) == T_NAUTY_OBJ)

#define NAUTY_GRAPH_PTR(o) (graph*)ADDR_OBJ(o)[0]
#define NAUTY_GRAPH_PTR_SPARSE(o) (sparsegraph*)ADDR_OBJ(o)[0]
#define NAUTY_GRAPH_SIZE(o) (size_t)ADDR_OBJ(o)[1]
#define NAUTY_GRAPH_ROWS(o) (size_t)ADDR_OBJ(o)[2]
#define NAUTY_GRAPH_COLS(o) (size_t)ADDR_OBJ(o)[3]

Obj NEW_NAUTY_GRAPH_OBJ(graph* graph_pointer, size_t size, size_t rows, size_t cols )
{
    Obj o;
    o = NewBag(T_NAUTY_OBJ, 4 * sizeof(Obj));
    ADDR_OBJ(o)[0] = (Obj)(graph_pointer);
    ADDR_OBJ(o)[1] = (Obj)(size);
    ADDR_OBJ(o)[2] = (Obj)(rows);
    ADDR_OBJ(o)[3] = (Obj)(cols);
    return o;
}

Obj NEW_NAUTY_SPARSEGRAPH_OBJ(sparsegraph* graph_pointer, size_t size, size_t rows, size_t cols )
{
    Obj o;
    o = NewBag(T_NAUTY_OBJ, 4 * sizeof(Obj));
    ADDR_OBJ(o)[0] = (Obj)(graph_pointer);
    ADDR_OBJ(o)[1] = (Obj)(size);
    ADDR_OBJ(o)[2] = (Obj)(rows);
    ADDR_OBJ(o)[3] = (Obj)(cols);
    return o;
}

void NautyObjFreeFunc( Obj o )
{
//     DYNFREE((graph*)ADDR_OBJ(o)[0],(size_t)ADDR_OBJ(o)[1]);
    if(ADDR_OBJ(o)[1])
        free(ADDR_OBJ(o)[0]);
}

void
writeautom(int *p, int n)
/* Called by allgroup.  Just writes the permutation p. */
{
    int i;

    for (i = 0; i < n; ++i) printf(" %2d",p[i]); printf("\n");
}

void userautomproc(int count, int* perm, int* orbits, int numorbits, int stabvertex, int n)
{
    Obj p   = NEW_PERM4(n);
    UInt4* ptr = ADDR_PERM4(p);
    
    for(int v= 0; v < n; v++){
      ptr[v] = perm[v];
    }
    
    AddList( automorphism_list, p );
    CHANGED_BAG( automorphism_list );
}

Obj NAUTY_GRAPH(Obj self, Obj source_list, Obj range_list, Obj nr_vertices_gap, Obj is_directed)
{
    DYNALLSTAT(graph,g,g_sz);
    size_t n,m, len_source, len_range, current_source, current_range, v;
    n = INT_INTOBJ( nr_vertices_gap );
    m = SETWORDSNEEDED(n);
//     DYNALLOC2(graph,g,g_sz,m,n,"malloc");
    g_sz = m*n;
    g = (graph*)malloc(g_sz*sizeof(graph));
    EMPTYGRAPH(g,m,n);
    len_source = LEN_PLIST( source_list );
    len_range = LEN_PLIST( range_list );
    if( len_source!=len_range ){
        ErrorQuit( "source and range lists are of different length", 0, 0 );
        return Fail;
    }
    for(v=1;v <= len_source;v++){
        current_source = INT_INTOBJ( ELM_PLIST( source_list, v ) ) - 1;
        current_range = INT_INTOBJ( ELM_PLIST( range_list, v ) ) - 1;
        if( is_directed == True ){
          ADDONEARC(g,current_source,current_range,m);
        }
        else{
          ADDONEEDGE(g,current_source,current_range,m);
        }
    }
    return NEW_NAUTY_GRAPH_OBJ( g, g_sz, n, m );
}


Obj NAUTY_DENSE_TO_SPARSE(Obj self, Obj nauty_graph )
{

    int n,m,v;

    graph* g = NAUTY_GRAPH_PTR( nauty_graph );
    size_t g_sz = NAUTY_GRAPH_SIZE( nauty_graph );
    n = NAUTY_GRAPH_ROWS( nauty_graph );
    m = NAUTY_GRAPH_COLS( nauty_graph );


    DYNALLSTAT(sparsegraph,sg,sg_sz);
    DYNALLOC2(sparsegraph,sg,sg_sz,m,n,"malloc");
    EMPTYGRAPH(sg,m,n);

    nauty_to_sg(g,sg,m,n);

    return NEW_NAUTY_SPARSEGRAPH_OBJ( sg, sg_sz, n, m );
}



Obj NAUTY_DENSE(Obj self, Obj nauty_graph, Obj is_directed, Obj color_data )
{
    DYNALLSTAT(graph,cg,cg_sz);
    DYNALLSTAT(int,lab,lab_sz);
    DYNALLSTAT(int,ptn,ptn_sz);
    DYNALLSTAT(int,orbits,orbits_sz);
    static optionblk options;
    if( is_directed == True ){
      static DEFAULTOPTIONS_DIGRAPH(temp_options);
      options=temp_options;
    }else{
      static DEFAULTOPTIONS_GRAPH(temp_options2);
      options=temp_options2;
    }
    
    statsblk stats;

    int n,m,v;
    set *gv;
    
    int nr_edges;
    
    int len_source;
    int len_range;
    
    int current_source;
    int current_range;
    
    Obj p;
    UInt4               *ptr;
    
    UInt global_list;
    
    graph* g = NAUTY_GRAPH_PTR( nauty_graph );
    size_t g_sz = NAUTY_GRAPH_SIZE( nauty_graph );
    n = NAUTY_GRAPH_ROWS( nauty_graph );
    m = NAUTY_GRAPH_COLS( nauty_graph );
    
    // Write automorphisms
    global_list = GVarName( "__NAUTYTRACESINTERFACE_GLOBAL_AUTOMORPHISM_GROUP_LIST" );
    automorphism_list = NEW_PLIST(T_PLIST, 0);
    SET_LEN_PLIST( automorphism_list, 0 );
    AssGVar( global_list, automorphism_list );
    options.userautomproc = userautomproc;
    
    options.getcanon = TRUE;

    nauty_check(WORDSIZE,m,n,NAUTYVERSIONID);
    
    // Allocate graph
    DYNALLOC2(graph,cg,cg_sz,m,n,"malloc");
    DYNALLOC1(int,lab,lab_sz,n,"malloc");
    DYNALLOC1(int,ptn,ptn_sz,n,"malloc");
    DYNALLOC1(int,orbits,orbits_sz,n,"malloc");

    EMPTYGRAPH(cg,m,n);
    
    if( color_data != False ){
        
        options.defaultptn = FALSE;
        
        Obj obj_lab = ELM_PLIST( color_data, 1 );
        Obj obj_ptn = ELM_PLIST( color_data, 2 );
        
        for(int i=0;i<n;i++){
            lab[ i ] = INT_INTOBJ( ELM_PLIST( obj_lab, i + 1 ) ) - 1;
            ptn[ i ] = INT_INTOBJ( ELM_PLIST( obj_ptn, i + 1 ) );
        }
    }
    
    // Call nauty
    densenauty(g,lab,ptn,orbits,&options,&stats,m,n,cg);
    
    //Convert labeling permutation
    p   = NEW_PERM4(n);
    ptr = ADDR_PERM4(p);
    
    for(int v= 0; v < n; v++){
      ptr[v] = lab[v];
    }
    
    Obj return_list = NEW_PLIST( T_PLIST, 2 );
    SET_LEN_PLIST( return_list, 2 );
    
    SET_ELM_PLIST( return_list, 1, automorphism_list );
    SET_ELM_PLIST( return_list, 2, p );
    
    automorphism_list = NEW_PLIST(T_PLIST, 0);
    SET_LEN_PLIST( automorphism_list, 0 );
    AssGVar( global_list, automorphism_list );
    
    DYNFREE(cg,cg_sz);
    DYNFREE(lab,lab_sz);
    DYNFREE(ptn,ptn_sz);
    DYNFREE(orbits,orbits_sz);
    
    return return_list;
}





Obj NAUTY_SPARSE(Obj self, Obj nauty_graph, Obj is_directed, Obj color_data )
{
    DYNALLSTAT(sparsegraph,csg,csg_sz);
    DYNALLSTAT(int,lab,lab_sz);
    DYNALLSTAT(int,ptn,ptn_sz);
    DYNALLSTAT(int,orbits,orbits_sz);
    static optionblk options;
    if( is_directed == True ){
      static DEFAULTOPTIONS_DIGRAPH(temp_options);
      options=temp_options;
    }else{
      static DEFAULTOPTIONS_SPARSEGRAPH(temp_options2);
      options=temp_options2;
    }
    
    statsblk stats;

    int n,m,v;
    set *gv;
    
    int nr_edges;
    
    int len_source;
    int len_range;
    
    int current_source;
    int current_range;
    
    Obj p;
    UInt4               *ptr;
    
    UInt global_list;
    
    sparsegraph* sg = NAUTY_GRAPH_PTR_SPARSE( nauty_graph );
    size_t sg_sz = NAUTY_GRAPH_SIZE( nauty_graph );
    n = NAUTY_GRAPH_ROWS( nauty_graph );
    m = NAUTY_GRAPH_COLS( nauty_graph );
    
    // Write automorphisms
    global_list = GVarName( "__NAUTYTRACESINTERFACE_GLOBAL_AUTOMORPHISM_GROUP_LIST" );
    automorphism_list = NEW_PLIST(T_PLIST, 0);
    SET_LEN_PLIST( automorphism_list, 0 );
    AssGVar( global_list, automorphism_list );
    options.userautomproc = userautomproc;
    
    options.getcanon = TRUE;

    nauty_check(WORDSIZE,m,n,NAUTYVERSIONID);
    
    // Allocate graph
    DYNALLOC2(sparsegraph,csg,csg_sz,m,n,"malloc");
    DYNALLOC1(int,lab,lab_sz,n,"malloc");
    DYNALLOC1(int,ptn,ptn_sz,n,"malloc");
    DYNALLOC1(int,orbits,orbits_sz,n,"malloc");

    EMPTYGRAPH(csg,m,n);
    
    if( color_data != False ){
        
        options.defaultptn = FALSE;
        
        Obj obj_lab = ELM_PLIST( color_data, 1 );
        Obj obj_ptn = ELM_PLIST( color_data, 2 );
        
        for(int i=0;i<n;i++){
            lab[ i ] = INT_INTOBJ( ELM_PLIST( obj_lab, i + 1 ) ) - 1;
            ptn[ i ] = INT_INTOBJ( ELM_PLIST( obj_ptn, i + 1 ) );
        }
    }
    
    // Call nauty
    sparsenauty(sg,lab,ptn,orbits,&options,&stats,csg);
    
    //Convert labeling permutation
    p   = NEW_PERM4(n);
    ptr = ADDR_PERM4(p);
    
    for(int v= 0; v < n; v++){
      ptr[v] = lab[v];
    }
    
    Obj return_list = NEW_PLIST( T_PLIST, 2 );
    SET_LEN_PLIST( return_list, 2 );
    
    SET_ELM_PLIST( return_list, 1, automorphism_list );
    SET_ELM_PLIST( return_list, 2, p );
    
    automorphism_list = NEW_PLIST(T_PLIST, 0);
    SET_LEN_PLIST( automorphism_list, 0 );
    AssGVar( global_list, automorphism_list );
    
    DYNFREE(csg,csg_sz);
    DYNFREE(lab,lab_sz);
    DYNFREE(ptn,ptn_sz);
    DYNFREE(orbits,orbits_sz);
    
    return return_list;
}


Obj NAUTY_SPARSE_GRAPH_PRINT_TEST(Obj self, Obj nauty_graph)
{

    int n,m;

    sparsegraph* g = NAUTY_GRAPH_PTR_SPARSE( nauty_graph );

    putgraph_sg(stderr, g, 0);
    return True;
}


Obj NAUTY_DENSE_GRAPH_PRINT_TEST(Obj self, Obj nauty_graph)
{

    int n,m;

    graph* g = NAUTY_GRAPH_PTR( nauty_graph );
    n = NAUTY_GRAPH_ROWS( nauty_graph );
    m = NAUTY_GRAPH_COLS( nauty_graph );

    putgraph(stderr, g, 0, m, n);
    return True;
}


Obj NautyDense(Obj self, Obj source_list, Obj range_list, Obj nr_vertices_gap, Obj is_directed, Obj color_data )
{
    Obj graph, return_list;
    UInt storage_var = GVarName( "__NAUTY_INTERNAL_GRAPH_STORAGE" );
    graph = NAUTY_GRAPH( 0, source_list,range_list,nr_vertices_gap,is_directed);
    AssGVar( storage_var, graph );
    return_list = NAUTY_DENSE( 0, graph, is_directed, color_data );
    AssGVar( storage_var, False );
    return return_list;
}


Obj NautySparse(Obj self, Obj source_list, Obj range_list, Obj nr_vertices_gap, Obj is_directed, Obj color_data )
{
    Obj graph, graph2, return_list;
    graph = NAUTY_GRAPH(self, source_list,range_list,nr_vertices_gap,is_directed);
    NautyObjFreeFunc( graph );
    graph2 = NAUTY_DENSE_TO_SPARSE(self, graph);
    return_list = NAUTY_SPARSE( self, graph2, is_directed, color_data );
    NautyObjFreeFunc( graph2 );
    return return_list;
}


typedef Obj (* GVarFunc)(/*arguments*/);

#define GVAR_FUNC_TABLE_ENTRY(srcfile, name, nparam, params) \
  {#name, nparam, \
   params, \
   (GVarFunc)name, \
   srcfile ":Func" #name }

// Table of functions to export
static StructGVarFunc GVarFuncs [] = {
    GVAR_FUNC_TABLE_ENTRY("NautyTracesInterface.c", NautyDense, 5, "source_list,range_list,n,is_directed,color_data"),
    GVAR_FUNC_TABLE_ENTRY("NautyTracesInterface.c", NautySparse, 5, "source_list,range_list,n,is_directed,color_data"),
    GVAR_FUNC_TABLE_ENTRY("NautyTracesInterface.c", NAUTY_GRAPH, 4, "source_list,range_list,n,is_directed" ),
    GVAR_FUNC_TABLE_ENTRY("NautyTracesInterface.c", NAUTY_DENSE_TO_SPARSE, 1, "source_list" ),
    GVAR_FUNC_TABLE_ENTRY("NautyTracesInterface.c", NAUTY_DENSE, 3, "graph,is_directed,color_data" ),
    GVAR_FUNC_TABLE_ENTRY("NautyTracesInterface.c", NAUTY_SPARSE, 3, "graph,is_directed,color_data" ),
    GVAR_FUNC_TABLE_ENTRY("NautyTracesInterface.c", NAUTY_DENSE_GRAPH_PRINT_TEST, 1, "graph" ),
    GVAR_FUNC_TABLE_ENTRY("NautyTracesInterface.c", NAUTY_SPARSE_GRAPH_PRINT_TEST, 1, "graph" ),

	{ 0 } /* Finish with an empty entry */

};

/******************************************************************************
*F  InitKernel( <module> )  . . . . . . . . initialise kernel data structures
*/
static Int InitKernel( StructInitInfo *module )
{
    /* init filters and functions                                          */
    InitHdlrFuncsFromTable( GVarFuncs );
    
    InitCopyGVar( "TheTypeNautyInternalGraphObject", &TheTypeNautyInternalGraphObject );

    T_NAUTY_OBJ = RegisterPackageTNUM("NautyInternalGraph", NautyObjTypeFunc );

    InitMarkFuncBags(T_NAUTY_OBJ, &MarkNoSubBags);
    InitFreeFuncBag(T_NAUTY_OBJ, &NautyObjFreeFunc );
    
    CopyObjFuncs[T_NAUTY_OBJ] = &NautyObjCopyFunc;
    CleanObjFuncs[T_NAUTY_OBJ] = &NautyObjCleanFunc;
    IsMutableObjFuncs[T_NAUTY_OBJ] = &NautyObjIsMutableFunc;


    /* return success                                                      */
    return 0;
}

/******************************************************************************
*F  InitLibrary( <module> ) . . . . . . .  initialise library data structures
*/
static Int InitLibrary( StructInitInfo *module )
{
    /* init filters and functions */
    InitGVarFuncsFromTable( GVarFuncs );

    /* return success                                                      */
    return 0;
}

/******************************************************************************
*F  InitInfopl()  . . . . . . . . . . . . . . . . . table of init functions
*/
static StructInitInfo module = {
 /* type        = */ MODULE_DYNAMIC,
 /* name        = */ "NautyTracesInterface",
 /* revision_c  = */ 0,
 /* revision_h  = */ 0,
 /* version     = */ 0,
 /* crc         = */ 0,
 /* initKernel  = */ InitKernel,
 /* initLibrary = */ InitLibrary,
 /* checkInit   = */ 0,
 /* preSave     = */ 0,
 /* postSave    = */ 0,
 /* postRestore = */ 0
};

StructInitInfo *Init__Dynamic( void )
{
    return &module;
}
