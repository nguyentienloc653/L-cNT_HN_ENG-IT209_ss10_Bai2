# 1. Base Image: sử dụng node:18-alpine gọn nhẹ để tối ưu kích thước image
FROM node:18-alpine

# 2. WORKDIR: thiết lập thư mục làm việc trong container
WORKDIR /app

# 3. ENV: khai báo biến môi trường cổng dịch vụ
ENV PORT=3000

# 4. COPY: sao chép file cấu hình dependency trước để tận dụng Docker layer caching
COPY package*.json ./

# 5. RUN: cài đặt các thư viện cần thiết
RUN npm install

# 6. COPY: sao chép toàn bộ mã nguồn vào thư mục làm việc trong container
COPY . .

# 7. EXPOSE: thông báo cổng lắng nghe của container
EXPOSE 3000

# 8. CMD: lệnh thực thi khởi chạy ứng dụng (exec form)
CMD ["node", "server.js"]
