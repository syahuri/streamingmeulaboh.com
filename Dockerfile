# --- Build stage not needed; static files served directly by nginx ---

FROM nginx:1.27-alpine

LABEL maintainer="ELKIFAH PRODUCTION"
LABEL project="streamingmeulaboh.com"

# Remove default nginx config and static files
RUN rm -rf /etc/nginx/conf.d/default.conf /usr/share/nginx/html/*

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy site files
COPY --chmod=644 index.html layanan.html portofolio.html harga.html tentang.html /usr/share/nginx/html/
COPY --chmod=644 robots.txt sitemap.xml /usr/share/nginx/html/
COPY assets/ /usr/share/nginx/html/assets/

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -q --spider http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
