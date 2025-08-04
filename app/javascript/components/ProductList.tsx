import React, { useEffect, useState } from "react";

import AddCartItemButton from "./AddCartItemButton";
import CartItemList from "./CartItemList";
import { Product } from "../types/Product";
import { CartItem } from "../types/CartItem";

const ProductList: React.FC = () => {
  const [products, setProducts] = useState<Product[]>([]);
  const [cartItems, setCartItems] = useState<CartItem[]>([]);

  // Fetch products
  const fetchProducts = async () => {
    const res = await fetch("/products.json");
    const data = await res.json();
    setProducts(data);
  };

  // Fetch cart items
  const fetchCartItems = async () => {
    const res = await fetch("/cart_items.json");
    const data = await res.json();
    setCartItems(data);
  };

  useEffect(() => {
    fetchProducts();
    fetchCartItems();
  }, []);

  return (
    <div>
      <ul className="grid grid-cols-2 gap-4">
        {products.map((product) => (
          <li key={product.id} className="p-4 border rounded-lg">
            <h3 className="font-semibold">{product.name}</h3>
            <p className="text-gray-600">{product.code}</p>
            <p>${product.price}</p>
            <AddCartItemButton productId={product.id} onAdd={fetchCartItems} />
          </li>
        ))}
      </ul>
      <CartItemList cartItems={cartItems} onRemove={fetchCartItems} />
    </div>
  );
};

export default ProductList;
