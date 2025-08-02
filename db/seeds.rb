# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Setup the default products
Product.find_or_create_by!(code: 'GR1', name: 'Green Tea', price: 3.11)
Product.find_or_create_by!(code: 'SR1', name: 'Strawberries', price: 5.00)
Product.find_or_create_by!(code: 'CF1', name: 'Coffee', price: 11.23)
