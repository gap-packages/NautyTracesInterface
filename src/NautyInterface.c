/*
 * NautyInterface: An interface to nauty
 */

#include "src/compiled.h"          /* GAP headers */
#include "../nauty26r7/nauty.h"
#include "../nauty26r7/naugroup.h"

Obj TestCommand(Obj self)
{
    return INTOBJ_INT(42);
}

Obj TestCommandWithParams(Obj self, Obj param, Obj param2)
{
    /* simply return the first parameter */
    return param;
}

void
writeautom(int *p, int n)
/* Called by allgroup.  Just writes the permutation p. */
{
    int i;

    for (i = 0; i < n; ++i) printf(" %2d",p[i]); printf("\n");
}

Obj NautyDense(Obj self, Obj source_list, Obj range_list, Obj nr_vertices_gap )
{
    /* DYNALLSTAT declares a pointer variable (to hold an array when it
     is allocated) and a size variable to remember how big the array is.
     Nothing is allocated yet.  */
    DYNALLSTAT(graph,g,g_sz);
    DYNALLSTAT(int,lab,lab_sz);
    DYNALLSTAT(int,ptn,ptn_sz);
    DYNALLSTAT(int,orbits,orbits_sz);
    static DEFAULTOPTIONS_GRAPH(options);
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
    
    grouprec *group;
    permrec *generators;
    
    int moved_points;
    
    options.userautomproc = groupautomproc;
    options.userlevelproc = grouplevelproc;
    
    n = INT_INTOBJ( nr_vertices_gap );
    
/* Default options are set by the DEFAULTOPTIONS_GRAPH macro above.
   Here we change those options that we want to be different from the
   defaults.  writeautoms=TRUE causes automorphisms to be written. */

    options.writeautoms = TRUE;


     /* The nauty parameter m is a value such that an array of
        m setwords is sufficient to hold n bits.  The type setword
        is defined in nauty.h.  The number of bits in a setword is
        WORDSIZE, which is 16, 32 or 64.  Here we calculate
        m = ceiling(n/WORDSIZE). */

    m = SETWORDSNEEDED(n);

         /* The following optional call verifies that we are linking
            to compatible versions of the nauty routines. */

    nauty_check(WORDSIZE,m,n,NAUTYVERSIONID);

         /* Now that we know how big the graph will be, we allocate
          * space for the graph and the other arrays we need. */

    DYNALLOC2(graph,g,g_sz,m,n,"malloc");
    DYNALLOC1(int,lab,lab_sz,n,"malloc");
    DYNALLOC1(int,ptn,ptn_sz,n,"malloc");
    DYNALLOC1(int,orbits,orbits_sz,n,"malloc");

    EMPTYGRAPH(g,m,n);
    
    len_source = INT_INTOBJ( LEN_PLIST( source_list ) );
    len_range = INT_INTOBJ( LEN_PLIST( range_list ) );
    
    if( len_source!=len_range ){
        ErrorMayQuit( "source and range lists are of different length", 0, 0 );
        return INTOBJ_INT( 0 );
    }
    
    for(v=1;v <= len_source;v++){
        current_source = INT_INTOBJ( ELM_PLIST( source_list, v ) ) - 1;
        current_range = INT_INTOBJ( ELM_PLIST( range_list, v ) ) - 1;
        ADDONEEDGE(g,current_source,current_range,m);
    }
    densenauty(g,lab,ptn,orbits,&options,&stats,m,n,NULL);
    
    p   = NEW_PERM4(n);
    ptr = ADDR_PERM4(p);
 
    for(v= 0; v < n; v++){
      ptr[v] = lab[v];
    }
    
    
    group = groupptr(FALSE);
    
    generators = group->levelinfo[0].gens;
    
    for(v=0;v < group->levelinfo[0].orbitsize;v++){
      writeautom( generators[v].p, group->n );
    }

//          /* Call the procedure writeautom() for every element of the group.
//             The first call is always for the identity. */
//                 
//             allgroup(group,writeautom);
    
//     
//     p = NEW_PLIST(T_PLIST, 2);
//     SET_LEN_PLIST(p, INTOBJ_INT( 2 ) );
//     
//     SET_ELM_PLIST(p,1,INTOBJ_INT( generators->p[0] ) );
//     SET_ELM_PLIST(p,2,INTOBJ_INT( generators->p[1] ) );
    
    return p;

}

typedef Obj (* GVarFunc)(/*arguments*/);

#define GVAR_FUNC_TABLE_ENTRY(srcfile, name, nparam, params) \
  {#name, nparam, \
   params, \
   (GVarFunc)name, \
   srcfile ":Func" #name }

// Table of functions to export
static StructGVarFunc GVarFuncs [] = {
    GVAR_FUNC_TABLE_ENTRY("NautyInterface.c", TestCommand, 0, ""),
    GVAR_FUNC_TABLE_ENTRY("NautyInterface.c", NautyDense, 3, "source_list,range_list,n"),
    GVAR_FUNC_TABLE_ENTRY("NautyInterface.c", TestCommandWithParams, 2, "param, param2"),

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
 /* name        = */ "NautyInterface",
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
