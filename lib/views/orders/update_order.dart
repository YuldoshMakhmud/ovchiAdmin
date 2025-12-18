import 'package:ovchiadmin/view_model/order_view_model.dart';
import 'package:flutter/material.dart';
import '../../models/order_model.dart';

class UpdateOrder extends StatefulWidget {
  final OrderModel orderData;
  const UpdateOrder({super.key, required this.orderData});

  @override
  State<UpdateOrder> createState() => _UpdateOrderState();
}

class _UpdateOrderState extends State<UpdateOrder> {
  OrderViewModel orderViewModel = OrderViewModel();

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: const [
          Icon(Icons.edit_note_rounded, color: Colors.blue),
          SizedBox(width: 8),
          Text(
            "Update Order Status",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              "Choose the new status for this order:",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),

          _buildActionButton(
            icon: Icons.check_circle_outline,
            label: "Mark as Paid",
            color: Colors.green,
            onPressed: () async {
              await orderViewModel.updateOrderStatus(
                docId: widget.orderData.id_order,
                orderData: {"status": "PAID"},
              );
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),

          SizedBox(height: 8),

          _buildActionButton(
            icon: Icons.local_shipping_outlined,
            label: "Mark as Shipped",
            color: Colors.orange,
            onPressed: () async {
              await orderViewModel.updateOrderStatus(
                docId: widget.orderData.id_order,
                orderData: {"status": "ON_THE_WAY"},
              );
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),

          SizedBox(height: 8),

          _buildActionButton(
            icon: Icons.done_all_rounded,
            label: "Mark as Delivered",
            color: Colors.blue,
            onPressed: () async {
              await orderViewModel.updateOrderStatus(
                docId: widget.orderData.id_order,
                orderData: {"status": "DELIVERED"},
              );
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),

          SizedBox(height: 8),

          _buildActionButton(
            icon: Icons.cancel_outlined,
            label: "Cancel Order",
            color: Colors.red,
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Cancel Order?"),
                  content: const Text(
                    "After canceling, this order cannot be changed. "
                    "The customer will need to place a new order.",
                    style: TextStyle(fontSize: 14),
                  ),
                  actions: [
                    TextButton(
                      child: const Text(
                        "No",
                        style: TextStyle(color: Colors.grey),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Yes, Cancel"),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await orderViewModel.updateOrderStatus(
                  docId: widget.orderData.id_order,
                  orderData: {"status": "CANCELLED"},
                );
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
