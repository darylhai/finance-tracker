class UserStocksController < ApplicationController
  
  def create
    # First check if the stock has already been added, 
    # so as to save doing an unecessary web lookup
    stock = Stock.find_by_ticker(params[:stock_ticker])
    if stock.blank?
      # If the stock has not been added, use the existing method to look it up
      stock = Stock.new_from_lookup(params[:stock_ticker])
      stock.save
    end
    # Create user stock instance variable
    @user_stock = UserStock.create(user: current_user, stock: stock)
    flash[:success] = "Stock #{@user_stock.stock.name} was successfully added to the portfolio"
    redirect_to my_portfolio_path
  end
  
  def destroy
    stock = Stock.find(params[:id])
    @user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id).first
    @user_stock.destroy
    flash[:notice] = "Stock was successfully removed from your portfolio"
    redirect_to my_portfolio_path
  end
    
end
