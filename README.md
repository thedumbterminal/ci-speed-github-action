# ci-speed-github-action
GitHub Action to upload to CI-Speed.

https://github.com/thedumbterminal/ci-speed

## Usage

### Inputs

* token - Your authentication token for CI-Speed
* results - The file name and path to the XML test results to upload

Please store your authentication token as a secret in your repository's settings, for more info see the GitHub documentation:

https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions

### Example
Add the following to your workflow YAML:

```
steps:

# Your test steps here

- name: Upload to CI-Speed
  if: success() || failure()
  uses: thedumbterminal/ci-speed-github-action@main
  with:
    token: ${{ secrets.CI_SPEED_AUTH_TOKEN }}
    results: test_results.xml
```

Please ensure to run the upload step after your steps that generate XML results.

Using the `if` statement in the example above, the upload step will still run if the project's tests fail.

### Uploading multiple results
Just add the step multiple times referencing the correct results file in each step.