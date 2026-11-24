---
name: gcloud-cli
description: Guidance for using the gcloud CLI to authenticate and inspect Google Cloud resources (projects, Compute, GKE, logs, storage, BigQuery). Use when the user asks to check, list, or inspect anything in Google Cloud, mentions GCP/gcloud/gsutil/bq, or hits auth/project-selection issues.
---

# gcloud CLI

The user works across multiple GCP projects. Always confirm or set the active project before running read commands, and prefer `--project=PROJECT_ID` on one-off commands over relying on the active config.

If the user asks you to run a `gcloud` command yourself and auth is missing or stale, do **not** try to log in for them — `gcloud auth login` is interactive. Suggest they run it via the `! <command>` prefix in the prompt so output lands in this session.

## Auth & project setup

```bash
# Interactive login (user must run this themselves)
gcloud auth login                          # human/CLI auth
gcloud auth application-default login      # for SDKs/libraries that use ADC

# See current state
gcloud auth list                           # active account
gcloud config list                         # active project, region, etc.

# Switch project for the active config
gcloud config set project PROJECT_ID

# Named configurations (cleanest way to juggle multiple projects)
gcloud config configurations list
gcloud config configurations create work-a
gcloud config configurations activate work-a
```

For a single command against a different project, pass `--project=PROJECT_ID` instead of switching configs.

## Compute Engine & GKE

```bash
# VMs
gcloud compute instances list --project=PROJECT_ID
gcloud compute instances describe NAME --zone=ZONE
gcloud compute ssh NAME --zone=ZONE

# GKE clusters
gcloud container clusters list --project=PROJECT_ID
gcloud container clusters get-credentials CLUSTER --region=REGION   # writes kubectl context
kubectl config current-context             # verify which cluster kubectl now points at
```

## Logs & monitoring

```bash
# Tail recent logs (most useful default)
gcloud logging read 'severity>=ERROR' --limit=50 --freshness=1h --project=PROJECT_ID

# Filter by resource (e.g. a Cloud Run service or GKE container)
gcloud logging read 'resource.type="cloud_run_revision" AND resource.labels.service_name="SVC"' \
  --limit=50 --format=json

# List available log names in a project
gcloud logging logs list --project=PROJECT_ID
```

Filters use the [Logging query language](https://cloud.google.com/logging/docs/view/logging-query-language). When in doubt, start with `severity>=WARNING` and a tight `--freshness`.

## Storage & BigQuery

```bash
# Cloud Storage (gcloud storage is the modern replacement for gsutil)
gcloud storage ls gs://BUCKET/
gcloud storage cat gs://BUCKET/path/file.json
gcloud storage du -s gs://BUCKET/prefix/   # size of a prefix

# BigQuery
bq ls --project_id=PROJECT_ID                          # datasets
bq ls PROJECT_ID:DATASET                               # tables
bq show --schema --format=prettyjson PROJECT_ID:DATASET.TABLE
bq query --use_legacy_sql=false --project_id=PROJECT_ID \
  'SELECT COUNT(*) FROM `PROJECT_ID.DATASET.TABLE` WHERE _PARTITIONDATE = CURRENT_DATE()'
```

For ad-hoc BQ queries, always include a partition/date filter on large tables — unbounded scans are slow and expensive.

## Common failure modes

- **`Reauthentication required`** → user runs `gcloud auth login` (interactive).
- **`The project property is not set`** → `gcloud config set project PROJECT_ID` or pass `--project=`.
- **`Permission denied` on a resource** → check `gcloud auth list` is the expected account; the wrong identity is the usual cause before IAM.
- **ADC errors from a library (not gcloud itself)** → user runs `gcloud auth application-default login`.
