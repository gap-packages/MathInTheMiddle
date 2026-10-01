This file describes changes in the MathInTheMiddle package.

## Unreleased

- Add `MitM_ProcedureCall` (#16) and `GetAllowedHeads`
- Rename `MitM_OMRecToGAPFunc` to `MitM_OMRecToGAP`
- Change `OMOBJ` to take a single object instead of a list
- Make `MitM_OMRecToGAP` return an `OME` object instead of entering a break loop
- Add `ViewString` methods for `OME`, `OMATTR` and `OMOBJ`; encode `call_id` as
  an `OMSTR`
- Export functions defined via `BindGlobal`, not only those installed via
  `InstallGlobalFunction`
- Link to the MathJax version of the manual by default; fix the homepage link

## 0.2 (2018-10-05)

## 0.1 (2018-10-05)
