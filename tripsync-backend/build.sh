#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
npm install

# Run database migrations
npm run migrate

echo "✅ Build completed successfully!"
