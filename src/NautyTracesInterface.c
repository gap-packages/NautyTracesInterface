/*
 * NautyTracesInterface: An interface to nauty
 */

#include "compiled.h" /* GAP headers */
#include <naugroup.h>
#include <nautinv.h>
#include <nauty.h>

#ifndef SELF_NAME
#define SELF_NAME CONST_CSTR_STRING(NAME_FUNC(self))
#endif

static Obj  automorphism_list;
static Obj  TheTypeNautyInternalGraphObject;
static UInt T_NAUTY_OBJ = 0;

static Obj NautyObjCopyFunc(Obj obj, Int mut)
{
    return obj;
}

static void NautyObjCleanFunc(Obj obj)
{
}

static Obj NautyObjTypeFunc(Obj o)
{
    return TheTypeNautyInternalGraphObject;
}

static inline int IS_NAUTY_GRAPH_OBJ(Obj o)
{
    return TNUM_OBJ(o) == T_NAUTY_OBJ;
}

static inline graph * NAUTY_GRAPH_PTR(Obj o)
{
    GAP_ASSERT(IS_NAUTY_GRAPH_OBJ(o));
    return (graph *)ADDR_OBJ(o)[0];
}

static inline size_t NAUTY_GRAPH_SIZE(Obj o)
{
    GAP_ASSERT(IS_NAUTY_GRAPH_OBJ(o));
    return (size_t)ADDR_OBJ(o)[1];
}

static inline size_t NAUTY_GRAPH_ROWS(Obj o)
{
    GAP_ASSERT(IS_NAUTY_GRAPH_OBJ(o));
    return (size_t)ADDR_OBJ(o)[2];
}

static inline size_t NAUTY_GRAPH_COLS(Obj o)
{
    GAP_ASSERT(IS_NAUTY_GRAPH_OBJ(o));
    return (size_t)ADDR_OBJ(o)[3];
}

static Obj NEW_NAUTY_GRAPH_OBJ(graph * graph_pointer,
                               size_t  size,
                               size_t  rows,
                               size_t  cols)
{
    Obj o;
    o = NewBag(T_NAUTY_OBJ, 4 * sizeof(Obj));
    ADDR_OBJ(o)[0] = (Obj)(graph_pointer);
    ADDR_OBJ(o)[1] = (Obj)(size);
    ADDR_OBJ(o)[2] = (Obj)(rows);
    ADDR_OBJ(o)[3] = (Obj)(cols);
    return o;
}

static void NautyObjFreeFunc(Obj o)
{
    //     DYNFREE((graph*)ADDR_OBJ(o)[0],(size_t)ADDR_OBJ(o)[1]);
    if (ADDR_OBJ(o)[1]) {
        free(ADDR_OBJ(o)[0]);
    }
}

#define RequireNautyGraph(funcname, op)                                      \
    RequireArgumentCondition(funcname, op, IS_NAUTY_GRAPH_OBJ(op),           \
                             "must be a nauty graph")

static void userautomproc(
    int count, int * perm, int * orbits, int numorbits, int stabvertex, int n)
{
    Obj     p = NEW_PERM4(n);
    UInt4 * ptr = ADDR_PERM4(p);

    for (int v = 0; v < n; v++) {
        ptr[v] = perm[v];
    }

    AddList(automorphism_list, p);
}

static Obj FuncNAUTY_GRAPH(Obj self,
                           Obj source_list,
                           Obj range_list,
                           Obj nr_vertices_gap,
                           Obj is_directed)
{
    RequirePossList(SELF_NAME, source_list);
    RequirePossList(SELF_NAME, range_list);
    RequireSameLength(SELF_NAME, source_list, range_list);
    RequireTrueOrFalse(SELF_NAME, is_directed);

    DYNALLSTAT(graph, g, g_sz);
    size_t n, m, len_source, len_range, current_source, current_range, v;
    n = GetSmallInt(SELF_NAME, nr_vertices_gap);
    m = SETWORDSNEEDED(n);
    //     DYNALLOC2(graph,g,g_sz,m,n,"malloc");
    g_sz = m * n;
    g = (graph *)calloc(g_sz, sizeof(graph));
    len_source = LEN_PLIST(source_list);
    len_range = LEN_PLIST(range_list);
    GAP_ASSERT(len_source == len_range);
    for (v = 1; v <= len_source; v++) {
        current_source = INT_INTOBJ(ELM_PLIST(source_list, v)) - 1;
        current_range = INT_INTOBJ(ELM_PLIST(range_list, v)) - 1;
        if (is_directed == True) {
            ADDONEARC(g, current_source, current_range, m);
        }
        else {
            ADDONEEDGE(g, current_source, current_range, m);
        }
    }
    return NEW_NAUTY_GRAPH_OBJ(g, g_sz, n, m);
}

static Obj
FuncNAUTY_DENSE(Obj self, Obj nauty_graph, Obj is_directed, Obj color_data)
{
    RequireNautyGraph(SELF_NAME, nauty_graph);
    RequireTrueOrFalse(SELF_NAME, is_directed);
    RequireArgumentCondition(SELF_NAME, color_data, color_data == False || IS_DENSE_LIST(color_data),
                             "must be a dense list or the value 'false'");

    DYNALLSTAT(graph, cg, cg_sz);
    DYNALLSTAT(int, lab, lab_sz);
    DYNALLSTAT(int, ptn, ptn_sz);
    DYNALLSTAT(int, orbits, orbits_sz);
    static optionblk options;
    if (is_directed == True) {
        static DEFAULTOPTIONS_DIGRAPH(temp_options);
        options = temp_options;
    }
    else {
        static DEFAULTOPTIONS_GRAPH(temp_options2);
        options = temp_options2;
    }

    statsblk stats;

    int   n, m, v;
    set * gv;

    int nr_edges;

    int len_source;
    int len_range;

    int current_source;
    int current_range;

    Obj     p;
    UInt4 * ptr;

    graph * g = NAUTY_GRAPH_PTR(nauty_graph);
    size_t  g_sz = NAUTY_GRAPH_SIZE(nauty_graph);
    n = NAUTY_GRAPH_ROWS(nauty_graph);
    m = NAUTY_GRAPH_COLS(nauty_graph);

    // Write automorphisms
    automorphism_list = NEW_PLIST(T_PLIST, 0);
    options.userautomproc = userautomproc;

    options.getcanon = TRUE;

    nauty_check(WORDSIZE, m, n, NAUTYVERSIONID);

    // Allocate graph
    DYNALLOC2(graph, cg, cg_sz, m, n, "malloc");
    DYNALLOC1(int, lab, lab_sz, n, "malloc");
    DYNALLOC1(int, ptn, ptn_sz, n, "malloc");
    DYNALLOC1(int, orbits, orbits_sz, n, "malloc");

    if (m > 0 && n > 0)
        EMPTYGRAPH(cg, m, n);

    if (color_data != False) {

        options.defaultptn = FALSE;

        Obj obj_lab = ELM_PLIST(color_data, 1);
        Obj obj_ptn = ELM_PLIST(color_data, 2);

        for (int i = 0; i < n; i++) {
            lab[i] = INT_INTOBJ(ELM_PLIST(obj_lab, i + 1)) - 1;
            ptn[i] = INT_INTOBJ(ELM_PLIST(obj_ptn, i + 1));
        }
    }

    // Call nauty
    densenauty(g, lab, ptn, orbits, &options, &stats, m, n, cg);

    // Convert labeling permutation
    p = NEW_PERM4(n);
    ptr = ADDR_PERM4(p);

    for (int v = 0; v < n; v++) {
        ptr[v] = lab[v];
    }

    Obj return_list = NewPlistFromArgs(automorphism_list, p);
    automorphism_list = 0;

    DYNFREE(cg, cg_sz);
    DYNFREE(lab, lab_sz);
    DYNFREE(ptn, ptn_sz);
    DYNFREE(orbits, orbits_sz);

    return return_list;
}


static Obj FuncNAUTY_DENSE_REPEATED(Obj self,
                                    Obj nauty_graph,
                                    Obj is_directed,
                                    Obj color_data)
{
    RequireNautyGraph(SELF_NAME, nauty_graph);
    RequireTrueOrFalse(SELF_NAME, is_directed);
    RequireArgumentCondition(SELF_NAME, color_data, color_data == False || IS_DENSE_LIST(color_data),
                             "must be a dense list or the value 'false'");

    DYNALLSTAT(graph, cg, cg_sz);
    DYNALLSTAT(int, lab, lab_sz);
    DYNALLSTAT(int, ptn, ptn_sz);
    DYNALLSTAT(int, orbits, orbits_sz);
    static optionblk options;
    if (is_directed == True) {
        static DEFAULTOPTIONS_DIGRAPH(temp_options);
        options = temp_options;
    }
    else {
        static DEFAULTOPTIONS_GRAPH(temp_options2);
        options = temp_options2;
    }

    statsblk stats;

    int   n, m, v;
    set * gv;

    int nr_edges;

    int len_source;
    int len_range;

    int current_source;
    int current_range;

    graph * g = NAUTY_GRAPH_PTR(nauty_graph);
    size_t  g_sz = NAUTY_GRAPH_SIZE(nauty_graph);
    n = NAUTY_GRAPH_ROWS(nauty_graph);
    m = NAUTY_GRAPH_COLS(nauty_graph);

    // Write automorphisms
    options.userautomproc = userautomproc;

    options.getcanon = TRUE;

    nauty_check(WORDSIZE, m, n, NAUTYVERSIONID);

    // Allocate graph
    DYNALLOC2(graph, cg, cg_sz, m, n, "malloc");
    DYNALLOC1(int, lab, lab_sz, n, "malloc");
    DYNALLOC1(int, ptn, ptn_sz, n, "malloc");
    DYNALLOC1(int, orbits, orbits_sz, n, "malloc");

    if (m > 0 && n > 0)
        EMPTYGRAPH(cg, m, n);

    Obj return_list = NEW_PLIST(T_PLIST, LEN_PLIST(color_data));

    for (int k = 1; k <= LEN_PLIST(color_data); k++) {
        automorphism_list = NEW_PLIST(T_PLIST, 0);

        if (color_data != False) {

            options.defaultptn = FALSE;

            Obj partition = ELM_PLIST(color_data, k);

            Obj obj_lab = ELM_PLIST(partition, 1);
            Obj obj_ptn = ELM_PLIST(partition, 2);

            for (int i = 0; i < n; i++) {
                lab[i] = INT_INTOBJ(ELM_PLIST(obj_lab, i + 1)) - 1;
                ptn[i] = INT_INTOBJ(ELM_PLIST(obj_ptn, i + 1));
            }
        }

        // Call nauty
        densenauty(g, lab, ptn, orbits, &options, &stats, m, n, cg);

        Obj     p;
        UInt4 * ptr;
        // Convert labeling permutation
        p = NEW_PERM4(n);
        ptr = ADDR_PERM4(p);

        for (int v = 0; v < n; v++) {
            ptr[v] = lab[v];
        }

        AddList(return_list, NewPlistFromArgs(automorphism_list, p));
    }

    automorphism_list = 0;

    DYNFREE(cg, cg_sz);
    DYNFREE(lab, lab_sz);
    DYNFREE(ptn, ptn_sz);
    DYNFREE(orbits, orbits_sz);

    return return_list;
}

// Table of functions to export
static StructGVarFunc GVarFuncs[] = {
    GVAR_FUNC(NAUTY_GRAPH, 4, "source_list,range_list,n,is_directed"),
    GVAR_FUNC(NAUTY_DENSE, 3, "graph,is_directed,color_data"),
    GVAR_FUNC(NAUTY_DENSE_REPEATED, 3, "graph,is_directed,color_data"),

    { 0 } /* Finish with an empty entry */

};

/******************************************************************************
 *F  InitKernel( <module> )  . . . . . . . . initialise kernel data structures
 */
static Int InitKernel(StructInitInfo * module)
{
    /* init filters and functions                                          */
    InitHdlrFuncsFromTable(GVarFuncs);

    InitGlobalBag(&automorphism_list, "NautyTracesInterface:automorphism_list");
    InitCopyGVar("TheTypeNautyInternalGraphObject",
                 &TheTypeNautyInternalGraphObject);

    T_NAUTY_OBJ = RegisterPackageTNUM("NautyInternalGraph", NautyObjTypeFunc);

    InitMarkFuncBags(T_NAUTY_OBJ, &MarkNoSubBags);
    InitFreeFuncBag(T_NAUTY_OBJ, &NautyObjFreeFunc);

    CopyObjFuncs[T_NAUTY_OBJ] = NautyObjCopyFunc;
    CleanObjFuncs[T_NAUTY_OBJ] = NautyObjCleanFunc;
    IsMutableObjFuncs[T_NAUTY_OBJ] = AlwaysNo;


    /* return success                                                      */
    return 0;
}

/******************************************************************************
 *F  InitLibrary( <module> ) . . . . . . .  initialise library data structures
 */
static Int InitLibrary(StructInitInfo * module)
{
    /* init filters and functions */
    InitGVarFuncsFromTable(GVarFuncs);

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

StructInitInfo * Init__Dynamic(void)
{
    return &module;
}
