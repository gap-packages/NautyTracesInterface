This file describes changes in the NautyTracesInterface package.

## Unreleased

- Require the `digraphs` package, and fix warnings when loading it together
  with this package (#54)
- Revise the manual, and fix a broken reference in it (#53)

## 0.3 (2025-03-20)

- Require GAP >= 4.12
- Update the bundled nauty to 2.7r1
- Add `NautyEdgeColoredDiGraph`, `NautyGraphNodeLabels`, `EdgesOfNautyGraph`,
  `VerticesOfNautyGraph`, `VertexColoursOfNautyGraph` and
  `IsIsomorphicGraphs`, and extend the manual (#50)
- Add `NautyDenseRepeated` for graphs with several colourings (#18)
- Support `CanonicalForm` and isomorphism testing for edge-coloured graphs
- Fix a crash for empty graphs, and validate input to kernel functions
- Speed up `CanonicalForm`, `NautyColorData` and isomorphism tests (#14, #15,
  #16)

## 0.2 (2018-03-01)

## 0.1 (2017-03-23)
