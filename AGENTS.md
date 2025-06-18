# Development Guidance

- Use test-driven development: write or update tests before implementing features or fixes.
- Always create tests for new behaviour and run them. Avoid skipping tests.
- When adding new Pascal examples under `tests/`, group related `.pas` cases into a single file whenever possible to keep the test suite small.
- Before running the transpiler or tests, install dependencies:
  ```bash
  pip install lark-parser
  ```
- During development, run only the test(s) relevant to your change. Run the full test suite with `pytest -q` before committing to verify nothing broke.
