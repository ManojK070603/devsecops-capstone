# DevSecOps Capstone — Secure Flask API

A containerized Flask API with automated testing, dependency auditing, Docker image security scanning, and a GitHub Actions CI pipeline.

## Project Overview

This project demonstrates a basic DevSecOps workflow by integrating application tests and security checks into continuous integration.

### Technology Stack

- **Application:** Python, Flask
- **Testing:** Pytest
- **Dependency Security:** pip-audit
- **Containerization:** Docker
- **Container Security:** Trivy
- **CI/CD:** GitHub Actions

## Architecture

```text
Developer Push / Pull Request
             |
             v
      GitHub Actions
             |
             v
      Install Dependencies
             |
             v
       Pytest Tests
             |
             v
       pip-audit
             |
             v
       Build Docker Image
             |
             v
      Trivy Image Scan
```

## API Endpoints

| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/` | Returns the API welcome message |
| GET | `/health` | Returns the application health status |

## Security Measures

- Uses the slim Python base image.
- Runs the application as a non-root user.
- Disables Python bytecode generation and enables unbuffered output.
- Installs Python dependencies without retaining pip's download cache.
- Upgrades available operating-system packages during the Docker build.
- Audits application dependencies with `pip-audit`.
- Scans Docker images with Trivy.
- Runs automated tests in GitHub Actions.

## Run Locally

Create and activate a virtual environment, then install development dependencies:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements-dev.txt
```

Run the tests:

```bash
python -m pytest -v
```

Audit application dependencies:

```bash
pip-audit -r requirements.txt
```

Start the API:

```bash
python app.py
```

The API listens on port `5050`.

Test the endpoints:

```bash
curl http://localhost:5050/
curl http://localhost:5050/health
```

## Build and Run with Docker

Build the image:

```bash
docker build -t devsecops-capstone:latest .
```

Run the container:

```bash
docker run --rm -p 5050:5050 devsecops-capstone:latest
```

Test the API:

```bash
curl http://localhost:5050/health
```

## Security Scanning

Scan the image with Trivy:

```bash
trivy image --severity HIGH,CRITICAL devsecops-capstone:latest
```

The current scan of image `v4` reported:

- 44 HIGH-severity Debian findings
- 4 HIGH-severity Python-package findings
- 0 CRITICAL findings

These are scanner findings, not necessarily distinct underlying vulnerabilities. Some findings repeat across related operating-system packages, and Python findings include packages bundled within pip.

The findings remain under investigation. A successful build and passing tests do not establish that an image is vulnerability-free. Review vendor advisories, available fixes, and scanner results before deploying the image to production.

## CI Pipeline

The GitHub Actions workflow runs on pushes, pull requests, and manual dispatch. It installs dependencies, runs Pytest, audits direct application dependencies, builds a Docker image, and scans it with Trivy.

The current Trivy workflow uses reporting mode (`exit-code: "0"`), so findings are reported without automatically failing the pipeline. A production pipeline should define an explicit vulnerability threshold and failure policy.

## Future Improvements

- Investigate and remediate outstanding Trivy findings.
- Review and pin the base image by digest.
- Add a vulnerability threshold that can fail CI.
- Generate and retain a Software Bill of Materials (SBOM).
- Add integration tests and container runtime checks.
- Deploy the application to a cloud environment.

## Repository

GitHub: https://github.com/ManojK070603/devsecops-capstone
