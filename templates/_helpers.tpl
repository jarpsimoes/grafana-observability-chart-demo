{{/*
This file defines reusable template functions for the Grafana demo services Helm chart.
*/}}

{{- define "grafana-demo-services.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "grafana-demo-services.serviceA" -}}
{{- printf "%s-service-a" (include "grafana-demo-services.fullname" .) -}}
{{- end -}}

{{- define "grafana-demo-services.serviceB" -}}
{{- printf "%s-service-b" (include "grafana-demo-services.fullname" .) -}}
{{- end -}}

{{- define "grafana-demo-services.serviceC" -}}
{{- printf "%s-service-c" (include "grafana-demo-services.fullname" .) -}}
{{- end -}}