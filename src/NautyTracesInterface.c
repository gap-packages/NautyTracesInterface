/*
 * NautyTracesInterface: An interface to nauty
 */

#include "src/compiled.h"          /* GAP headers */
#include <nauty.h>
#include <naugroup.h>
#include <nautinv.h>

static Obj automorphism_list;

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
    
    AssPlist( automorphism_list, count, p );
    CHANGED_BAG( automorphism_list );
}

Obj NautyDense(Obj self, Obj source_list, Obj range_list, Obj nr_vertices_gap, Obj is_directed, Obj color_data )
{
    
    // Declare nauty variables.
    DYNALLSTAT(graph,g,g_sz);
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
    
    n = INT_INTOBJ( nr_vertices_gap );
    
    // Write automorphisms
    automorphism_list = NEW_PLIST(T_PLIST, 0);
    SET_LEN_PLIST( automorphism_list, 0 );
    options.userautomproc = userautomproc;
    
    options.getcanon = TRUE;

    m = SETWORDSNEEDED(n);

    nauty_check(WORDSIZE,m,n,NAUTYVERSIONID);
    
    // Allocate graph
    DYNALLOC2(graph,g,g_sz,m,n,"malloc");
    DYNALLOC2(graph,cg,cg_sz,m,n,"malloc");
    DYNALLOC1(int,lab,lab_sz,n,"malloc");
    DYNALLOC1(int,ptn,ptn_sz,n,"malloc");
    DYNALLOC1(int,orbits,orbits_sz,n,"malloc");

    EMPTYGRAPH(g,m,n);
    EMPTYGRAPH(cg,m,n);
    
    // Create nauty graph
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

	{ 0 } /* Finish with an empty entry */

};

/******************************************************************************
*F  InitKernel( <module> )  . . . . . . . . initialise kernel data structures
*/
static Int InitKernel( StructInitInfo *module )
{
    /* init filters and functions                                          */
    InitHdlrFuncsFromTable( GVarFuncs );

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
