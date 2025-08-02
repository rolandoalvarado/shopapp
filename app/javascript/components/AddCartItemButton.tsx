import React from "react";

type AddCartItemButtonProps = {
  productId: number;
  onAdd?: () => void;
};

const AddCartItemButton: React.FC<AddCartItemButtonProps> = ({ productId, onAdd }) => {
  const handleAddToCart = async () => {
    try {
      const csrfToken = (document.querySelector('meta[name="csrf-token"]') as HTMLMetaElement)?.content;

      const response = await fetch("/cart_items", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken,
        },
        body: JSON.stringify({ product_id: productId, quantity: 1 }),
      });

      if (response.ok) {
        onAdd?.();
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
      className="mt-2 px-4 py-1 bg-green-600 hover:bg-green-700 text-white rounded"
    >
      Add to Cart
    </button>
  );
};

export default AddCartItemButton;
