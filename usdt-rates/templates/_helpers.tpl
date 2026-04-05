{{- define "usdt-rates.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "usdt-rates.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "usdt-rates.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "usdt-rates.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "usdt-rates.labels" -}}
helm.sh/chart: {{ include "usdt-rates.chart" . }}
{{ include "usdt-rates.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "usdt-rates.selectorLabels" -}}
app.kubernetes.io/name: {{ include "usdt-rates.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "usdt-rates.postgresqlHost" -}}
{{- if .Values.postgresHostOverride }}
{{- .Values.postgresHostOverride }}
{{- else }}
{{- printf "%s-postgresql" .Release.Name }}
{{- end }}
{{- end }}

{{- define "usdt-rates.postgresURL" -}}
{{- if .Values.postgresql.enabled }}
{{- $u := "postgres" }}
{{- $p := .Values.postgresql.auth.postgresPassword | urlquery }}
{{- $h := include "usdt-rates.postgresqlHost" . }}
{{- $d := .Values.postgresql.auth.database }}
{{- printf "postgres://%s:%s@%s:5432/%s?sslmode=disable" $u $p $h $d }}
{{- else }}
{{- required "externalPostgresURL is required when postgresql.enabled is false" .Values.externalPostgresURL }}
{{- end }}
{{- end }}
