# ベースイメージとして指定されたイメージを使用
FROM mcr.microsoft.com/devcontainers/ruby:1-3.3-bullseye

# Node.jsをインストール
RUN echo "[Dockerfile] Installing Node.js" && \
    apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get install -y nodejs

# Railsをインストール
RUN echo "[Dockerfile] Installing Rails" && \
    gem install rails -v '8.0.1'

# entrypoint.shをコンテナ内にコピー
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# 作業ディレクトリ設定 & ソースコピー
WORKDIR /workspace
COPY . /workspace

# 必要なポートを公開
EXPOSE 3000 8000

# コンテナ起動時にentrypoint.shを実行
ENTRYPOINT ["entrypoint.sh"]