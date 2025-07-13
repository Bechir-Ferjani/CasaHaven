#!/bin/bash

echo "🚀 Starting CasaHaven Docker Environment..."

# Build and start containers
echo "📦 Building and starting containers..."
docker compose up -d --build

# Wait for MySQL to be ready
echo "⏳ Waiting for MySQL to be ready..."
sleep 30

# Run Laravel setup commands inside the PHP container
echo "🔧 Setting up Laravel application..."

# Generate application key if not exists
docker compose exec app php artisan key:generate --ansi

# Run database migrations
echo "📊 Running database migrations..."
docker compose exec app php artisan migrate --force

# Create storage link
echo "🔗 Creating storage link..."
docker compose exec app php artisan storage:link

# Set proper permissions
echo "🔐 Setting proper permissions..."
docker compose exec app chown -R www-data:www-data /var/www/html/storage
docker compose exec app chown -R www-data:www-data /var/www/html/bootstrap/cache

# Clear and cache config
echo "🧹 Clearing and caching configuration..."
docker compose exec app php artisan config:clear
docker compose exec app php artisan cache:clear
docker compose exec app php artisan view:clear
docker compose exec app php artisan route:clear

echo "✅ Setup complete!"
echo "🌐 Your application is now running at: http://localhost:8000"
echo "🗄️  MySQL is available at: localhost:3306"
echo ""
echo "📝 Useful commands:"
echo "  - View logs: docker compose logs -f"
echo "  - Stop containers: docker compose down"
echo "  - Access PHP container: docker compose exec app bash"
echo "  - Access MySQL: docker compose exec db mysql -u casahaven_user -p casahaven"
