# Bước 1: Chọn image Python làm base
FROM python:3.11.9-slim

# Bước 2: Cài đặt các thư viện cần thiết và dependencies cho hệ thống
RUN apt-get update && apt-get install -y libpq-dev

# Bước 3: Đặt thư mục làm việc trong container
WORKDIR /app

# Bước 4: Cài đặt các thư viện Python từ requirements.txt
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


# Bước 5: Copy mã nguồn ứng dụng vào container
COPY . .
# Sao chép file cấu hình Nginx vào container
COPY nginx.conf /etc/nginx/nginx.conf

RUN python manage.py collectstatic --noinput

# Bước 6: Cung cấp cổng mà ứng dụng Django sẽ chạy
EXPOSE 8000

# 5️⃣ Lệnh mặc định (sẽ bị override bởi docker-compose)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "greatkart.wsgi:application"]
