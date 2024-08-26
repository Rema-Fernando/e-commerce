class ProductsController < ApplicationController
  def search
    category_name = params[:category_name]
    product_name = params[:product_name]

    if category_name.present?
      category = Category.find_by(name: category_name)
      product = Product.where(category_id: category.id)
      render json: {message: "Category not found"}, status: 404 and return unless category.present?
      render json: {categories: product}, status: 200
    elsif product_name.present?
      product = Product.find_by(name: product_name)
      render json: {message: "Product not found"}, status: 404 and return unless product.present?
      render json: {products: product}, status: 200
    else
      render json: {message: "Provide category name or product name"}, status: 400
    end
  end

  def update
    category_name = params[:category_name]
    product_name = params[:product_name]
    if category_name.present?
      category = Category.find_by(name:category_name).update(permitted_params)
    elsif product_name.present?
      product = Product.find_by(name: product_name).update(permitted_params)
    end
  end

  private

  def permitted_params
        
  end
end
