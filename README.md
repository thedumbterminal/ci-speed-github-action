# ci-speed-github-action
GitHub Action to upload to CI-Speed.

https://github.com/thedumbterminal/ci-speed

## Usage

### Inputs

#### token
Your authentication token for CI-Speed

Please store your authentication token as a secret in your repository's settings, for more info see the GitHub documentation:

https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions

#### results
The file name and path to the XML test results to upload

#### action
The action to be performed for CI-Speed

The following actions are supported:

* upload - Upload results to CI-Speed.
* start - Log the start time if a CI run.
* finish - Log the finish time of a CI run.

### Example
Add the following to your workflow YAML:

```
steps:

# Your test steps here

- name: Upload to CI-Speed
  if: success() || failure()
  uses: thedumbterminal/ci-speed-github-action@v1
  with:
    token: ${{ secrets.CI_SPEED_AUTH_TOKEN }}
    results: test_results.xml
```

Please ensure to run the upload step after your steps that generate XML results.

Using the `if` statement in the example above, the upload step will still run if the project's tests fail.

### Uploading multiple results
Use multiple filenames in the `results` argument separated by spaces. For example:

```
  with:
    results: results1.xml results2.xml
```

### Environment Variables

* CI_SPEED_HOST - API host name if a custom CI-Speed instance is being used.
