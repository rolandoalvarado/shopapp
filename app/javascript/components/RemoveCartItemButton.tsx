import React from "react";

type RemoveCartItemButtonProps = {
  cartItemId: number;
  onRemove: (id: number) => void;
};

const RemoveCartItemButton: React.FC<RemoveCartItemButtonProps> = ({
  cartItemId,
  onRemove,
}) => {
  const handleRemove = async () => {
    const confirmed = window.confirm("Remove this item from cart?");
    if (!confirmed) return;

    try {
      const csrfToken = document
        .querySelector('meta[name="csrf-token"]')
        ?.getAttribute("content");

      const res = await fetch(`/cart_items/${cartItemId}`, {
        method: "DELETE",
        headers: {
          "X-CSRF-Token": csrfToken || "",
        },
      });

      if (res.ok) {
        onRemove(cartItemId);
      } else {
        alert("Failed to remove item.");
      }
    } catch (error) {
      console.error("Remove cart item error:", error);
    }
  };

  return (
    <button
      onClick={handleRemove}
      className="mt-2 px-4 py-1 bg-red-600 hover:bg-red-700 text-white rounded"
    >
      Remove
    </button>
  );
};

export default RemoveCartItemButton;
