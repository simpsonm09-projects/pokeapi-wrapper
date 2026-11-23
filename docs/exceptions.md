# Exceptions

One row per rule this repository cannot meet yet. The reason and the revisit date
are required. The shared `standard` job reads this file.

| Rule | Reason | Revisit |
| --- | --- | --- |
| `C5.1` | The median of the last 20 pull request runs at the audit snapshot was 99 s. The first run after this change took 41 s from the first job starting to the last required check finishing, so the added pip cache and the parallel `fmt` job bring the pull request path inside the 60 s budget. The historical median stays above it until 20 new runs land; re-measure it then and drop this row if it holds. | 2027-02-28 |
| `C7.3` | The wrapper is a Python 3.12 FastAPI application built and tested with `pip` and `pytest`, and linted and formatted with `ruff`. Porting it to Bun TypeScript would rewrite the HTTP client, the Pydantic models and the test suite, so the repository keeps the Python toolchain behind the core recipe names (`fmt`, `fmt-check`, `lint`, `test`, `coverage`, `spec`). | 2027-05-31 |
| `C7.4` | `scripts/prune.mjs` and `scripts/agent-files.mjs` are still `.mjs` on Node. They run on the pinned Node until the C7.3 migration brings a TypeScript toolchain to the repository. | 2027-05-31 |
