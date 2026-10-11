# Bài tập 2: Đóng gói ứng dụng Web Backend bằng Single-stage Dockerfile

## 1. Giới thiệu
Dự án đóng gói một ứng dụng Web API đơn giản viết bằng **Node.js/Express** thành **Docker Image** sử dụng kỹ thuật **Single-stage Dockerfile** nhằm phục vụ việc kiểm thử và triển khai ứng dụng.

## 2. Cấu trúc thư mục
Đường dẫn nộp bài: `homework/session_10/ex2/`

```text
homework/session_10/ex2/
├── .dockerignore       # Danh sách file/thư mục bỏ qua khi build Docker image
├── Dockerfile          # Tệp cấu hình đóng gói Single-stage Docker image
├── package.json        # Định nghĩa dự án và các thư viện phụ thuộc (express)
├── server.js           # Mã nguồn ứng dụng REST API
└── README.md           # Hướng dẫn chi tiết cách build, chạy và kiểm tra
```

---

## 3. Chi tiết Dockerfile Single-stage
Tệp [Dockerfile](file:///e:/Ki%20IV/Java%20Funtamental/Session10/homework/session_10/ex2/Dockerfile) gồm đầy đủ các chỉ thị theo chuẩn:
- `FROM node:18-alpine`: Sử dụng base image Alpine siêu nhẹ, bảo mật và tiết kiệm tài nguyên.
- `WORKDIR /app`: Đặt thư mục làm việc mặc định trong container là `/app`.
- `ENV PORT=3000`: Thiết lập biến môi trường cổng ứng dụng lắng nghe.
- `COPY package*.json ./`: Sao chép file cấu hình dependency trước để tận dụng cơ chế caching layer của Docker.
- `RUN npm install`: Cài đặt các phụ thuộc cần thiết cho ứng dụng.
- `COPY . .`: Sao chép toàn bộ mã nguồn vào container.
- `EXPOSE 3000`: Khai báo cổng 3000 mà container sẽ lắng nghe khi chạy.
- `CMD ["node", "server.js"]`: Sử dụng **exec form** (dạng mảng JSON) để tiến trình Node.js nhận trực tiếp tín hiệu hệ thống (`SIGTERM`, `SIGINT`).

---

## 4. Hướng dẫn Build & Kiểm tra

### Bước 1: Di chuyển vào thư mục bài tập
Mở Terminal / PowerShell và chuyển vào thư mục chứa mã nguồn:
```bash
cd homework/session_10/ex2
```

### Bước 2: Build Docker Image
Xây dựng Docker image với tên `hw-backend:v1`:
```bash
docker build -t hw-backend:v1 .
```

### Bước 3: Khởi chạy Container
Chạy container ở chế độ chạy ngầm (detached mode `-d`), đặt tên container là `app-single-stage` và ánh xạ cổng máy chủ `8080` vào cổng container `3000`:
```bash
docker run -d --name app-single-stage -p 8080:3000 hw-backend:v1
```

### Bước 4: Kiểm tra trạng thái và logs của Container
1. Kiểm tra container đang chạy:
```bash
docker ps
```
*Kết quả mong đợi:* Container `app-single-stage` có trạng thái `Up ...` và hiển thị ánh xạ cổng `0.0.0.0:8080->3000/tcp`.

2. Xem log ứng dụng:
```bash
docker logs app-single-stage
```
*Kết quả mong đợi:*
```text
Server listening on port 3000
```

### Bước 5: Gửi yêu cầu kiểm tra API qua curl
Kiểm tra kết quả phản hồi HTTP và dữ liệu JSON:
```bash
curl -i http://localhost:8080/
```

*Kết quả mong đợi:*
```http
HTTP/1.1 200 OK
X-Powered-By: Express
Content-Type: application/json; charset=utf-8
Content-Length: 60
ETag: ...
Date: ...
Connection: keep-alive
Keep-Alive: timeout=5

{"status":"success","message":"Hello from Docker Single-stage!"}
```

---

## 5. Dọn dẹp tài nguyên (Optional)
Khi hoàn tất kiểm tra, dọn dẹp container và image:
```bash
# Dừng container
docker stop app-single-stage

# Xóa container
docker rm app-single-stage

# Xóa image đã build
docker rmi hw-backend:v1
```
