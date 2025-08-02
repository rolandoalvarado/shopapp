import React from "react";

const CartItemButton = ({ productId }) => {
  const handleAddToCart = async () => {
    try {
      const response = await fetch("/cart_items", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        },
        body: JSON.stringify({ product_id: productId, quantity: 1 }),
      });

      if (response.ok) {
        const result = await response.json();
        alert("Item added to cart!");
      } else {
        alert("Failed to add item.");
      }
    } catch (error) {
      console.error("Add to cart error:", error);
    }
  };

  return (
    <button
      onClick={handleAddToCart}
      className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 cursor-pointer"
    >
      Add to Cart
    </button>
  );
};

export default CartItemButton;
