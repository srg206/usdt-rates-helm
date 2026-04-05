# usdt-rates-helm

Helm-чарт для развёртывания приложения **usdt-rates** в Kubernetes: несколько реплик приложения и один экземпляр PostgreSQL (Bitnami chart, primary).

## Требования

- Kubernetes (локально: [Minikube](https://minikube.sigs.k8s.io/docs/start/) или аналог)
- [Helm 3](https://helm.sh/docs/intro/install/)
- Docker (для сборки образа приложения)

Исходный код и `Dockerfile` приложения — в соседнем репозитории **usdt-rates**. По умолчанию ниже предполагается клон рядом: `../usdt-rates`.

## Сборка образа для Minikube

```bash
eval "$(minikube docker-env)"
cd ../usdt-rates
docker build -t usdt-rates:latest .
```

В `values.yaml` (или `--set`) для Minikube задайте `image.pullPolicy: Never`, чтобы не тянуть образ из реестра.

## Зависимости чарта

```bash
cd usdt-rates-helm
make helm-deps
# или вручную:
helm repo add bitnami https://charts.bitnami.com/bitnami
helm dependency update ./usdt-rates
```

## Установка

```bash
helm upgrade --install usdt-rates ./usdt-rates \
  --namespace usdt-rates --create-namespace \
  --set image.pullPolicy=Never
```

Проверка:

```bash
kubectl get pods -n usdt-rates
minikube service usdt-rates-usdt-rates -n usdt-rates --url
```

Или port-forward:

```bash
kubectl port-forward -n usdt-rates svc/usdt-rates-usdt-rates 50051:50051 8080:8080
```

Миграции БД выполняются Helm hook’ом (Job) после install/upgrade, если `migrations.enabled: true`.

## Внешняя БД

Отключите встроенный PostgreSQL и передайте строку подключения:

```bash
helm upgrade --install usdt-rates ./usdt-rates \
  --set postgresql.enabled=false \
  --set externalPostgresURL='postgres://user:pass@host:5432/db?sslmode=disable'
```

## Структура

- `usdt-rates/` — Helm chart (`Chart.yaml`, `values.yaml`, `templates/`, `migrations/*.sql`).
