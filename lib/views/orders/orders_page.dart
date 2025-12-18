import 'package:ovchiadmin/providers/admin_web_panel_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/order_model.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String _searchQuery = "";
  String _selectedStatus = "All";

  Widget statusBadge({
    required String text,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }

  Widget setStatus(String status) {
    if (status == "PAID") {
      return statusBadge(
        text: "PAID",
        bgColor: Colors.lightGreen,
        textColor: Colors.white,
      );
    } else if (status == "ON_THE_WAY") {
      return statusBadge(
        text: "ON THE WAY",
        bgColor: Colors.yellow,
        textColor: Colors.black,
      );
    } else if (status == "DELIVERED") {
      return statusBadge(
        text: "DELIVERED",
        bgColor: Colors.green.shade700,
        textColor: Colors.white,
      );
    } else {
      return statusBadge(
        text: "CANCELLED",
        bgColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.deepPurple.shade200,
        title: const Text("Orders"),
        centerTitle: true,
      ),
      body: Consumer<AdminWebPanelProvider>(
        builder: (context, value, child) {
          List<OrderModel> allOrdersList = OrderModel.fromJsonList(
            value.ordersList,
          );

          // Apply filters
          List<OrderModel> filteredOrders = allOrdersList.where((order) {
            final adminInputText = _searchQuery.toLowerCase();
            final inputFromTextField =
                order.name.toLowerCase().contains(adminInputText) ||
                order.id_order.toLowerCase().contains(adminInputText);
            final chosenFilterOption =
                _selectedStatus == "All" || order.status == _selectedStatus;
            return inputFromTextField && chosenFilterOption;
          }).toList();

          return Column(
            children: [
              // Search and filter controls
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    // Search Field
                    Expanded(
                      flex: 3,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.trim();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search by customer or order ID",
                          prefixIcon: Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Dropdown Filter
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        items: const [
                          DropdownMenuItem(value: "All", child: Text("All")),
                          DropdownMenuItem(value: "PAID", child: Text("PAID")),
                          DropdownMenuItem(
                            value: "ON_THE_WAY",
                            child: Text("ON THE WAY"),
                          ),
                          DropdownMenuItem(
                            value: "DELIVERED",
                            child: Text("DELIVERED"),
                          ),
                          DropdownMenuItem(
                            value: "CANCELLED",
                            child: Text("CANCELLED"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Display Orders
              Expanded(
                child: filteredOrders.isEmpty
                    ? const Center(
                        child: Text("No matching allOrdersList found"),
                      )
                    : ListView.builder(
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          final orderDate = DateTime.fromMillisecondsSinceEpoch(
                            order.created_at,
                          );
                          final formattedDate = DateFormat(
                            'MMM d, yyyy • h:mm a',
                          ).format(orderDate);

                          return Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      "/order_details",
                                      arguments: order,
                                    );
                                  },
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  title: Center(
                                    child: Text(
                                      "Order ID#   ${order.id_order}",
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Purchase by ${order.name}\nOrder placed on $formattedDate",
                                  ),
                                  trailing: setStatus(order.status),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
