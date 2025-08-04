import React, { useEffect, useState } from "react";

import AddCartItemButton from "./AddCartItemButton";
import CartItemList from "./CartItemList";
import CheckoutSuccess from "./CheckoutSuccess";
import { Product } from "../types/Product";
import { CartItem } from "../types/CartItem";

const ProductList: React.FC = () => {
  const [products, setProducts] = useState<Product[]>([]);
  const [cartItems, setCartItems] = useState<CartItem[]>([]);
  const [checkoutCompleted, setCheckoutCompleted] = useState(false);

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

  const handleCheckout = async () => {
    try {
      const csrfToken = document
        .querySelector('meta[name="csrf-token"]')
        ?.getAttribute("content");

      const res = await fetch("/checkout", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken || "",
        },
        body: JSON.stringify({ cart_items: cartItems }),
      });

      if (res.ok) {
        setCheckoutCompleted(true);
        setCartItems([]);
      } else {
        console.error("Checkout failed");
      }
    } catch (error) {
      console.error("Checkout error:", error);
    }
  };

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
      {checkoutCompleted ? (
        <CheckoutSuccess />
      ) : (
        <>
          <CartItemList
            cartItems={cartItems}
            onRemove={fetchCartItems}
            onUpdateCartItems={setCartItems}
          />
          {cartItems.length > 0 && (
            <div className="mt-4">
              <button
                onClick={handleCheckout}
                className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
              >
                Checkout
              </button>
            </div>
          )}
        </>
      )}
    </div>
  );
};

export default ProductList;
