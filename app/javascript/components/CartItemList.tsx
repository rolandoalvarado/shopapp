import React, { useState } from "react";
import RemoveCartItemButton from "./RemoveCartItemButton";
import { CartItem } from "../types/CartItem";

type CartItemListProps = {
  cartItems: CartItem[];
  onRemove: (id: number) => void;
  onUpdateCartItems: (updatedItems: CartItem[]) => void;
};

const CartItemList: React.FC<CartItemListProps> = ({ cartItems, onRemove, onUpdateCartItems }) => {
  const [loading, setLoading] = useState(false);

  if (!cartItems || cartItems.length === 0) {
    return <div className="mt-6 text-gray-600">Cart is empty.</div>;
  }

  const total = cartItems.reduce((sum, item) => sum + Number(item.total_price), 0).toFixed(2);

  return (
    <div className="mt-6">
      <h2 className="text-xl font-semibold mb-2">Cart Items</h2>
      <ul className="space-y-2">
        {cartItems.map((item) => (
          <li
            key={item.id}
            className="flex justify-between items-center border p-3 rounded-md bg-gray-50"
          >
            <div>
              <div className="font-medium">{item.product.name}</div>
              <div className="text-sm text-gray-600">
                Qty: {item.quantity}
                {item.adjusted_price !== item.product.price && (
                  <span className="text-sm text-green-600 ml-2">(Discount Applied)</span>
                )}
              </div>
              <div className="text-sm text-gray-600">
                Price: ${item.adjusted_price.toFixed(2)}{" "}
                {item.adjusted_price !== item.product.price && (
                  <span className="line-through text-red-400 ml-1">
                    ${item.product.price.toFixed(2)}
                  </span>
                )}
              </div>
              <div className="text-sm font-semibold">
                Subtotal: ${item.total_price.toFixed(2)}
              </div>
              {item.discount && item.discount > 0 && (
                <div className="text-xs text-green-500">
                  You saved ${item.discount.toFixed(2)}
                </div>
              )}
            </div>
            <div>
              <RemoveCartItemButton cartItemId={item.id} onRemove={() => onRemove(item.id)} />
            </div>
          </li>
        ))}
      </ul>
      <div className="mt-4 font-semibold">Total: ${total}</div>
    </div>
  );
};

export default CartItemList;
