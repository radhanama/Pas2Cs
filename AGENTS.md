# Development Guidance

- Use test-driven development: write or update tests before implementing features or fixes.
- Always create tests for new behaviour and run them. Avoid skipping tests.
- When adding new Pascal examples under `tests/`, **always** group related `.pas` cases into a single file whenever possible to keep the test suite small and organized.
- When running tests, do not stop execution unless a test clearly hangs for an excessively long time. Prematurely killing slow tests often wastes more time by forcing additional reruns.
- Before running the transpiler or tests, install dependencies:
  ```bash
  pip install lark-parser
  ```
- During development, run only the test(s) relevant to your change. Run the full test suite with `pytest -q` before committing to verify nothing broke.
- Comments emitted in generated C# should use block style `/* */` instead of line style `//`.
