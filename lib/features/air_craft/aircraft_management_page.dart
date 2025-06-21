import 'package:flight_sync_admin/core/constants/responses.dart';
import 'package:flight_sync_admin/features/air_craft/bloc/aircraft_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_sync_admin/core/widgets/confirmation_dialog.dart';
import 'package:flight_sync_admin/core/widgets/add_item_dialog.dart';
import 'package:flight_sync_admin/core/widgets/search_field.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AircraftManagementPage extends StatefulWidget {
  const AircraftManagementPage({super.key});

  @override
  State<AircraftManagementPage> createState() => _AircraftManagementPageState();
}

class _AircraftManagementPageState extends State<AircraftManagementPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddAircraftDialog(BuildContext context) {
    final modelController = TextEditingController();
    final seatsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AddItemDialog(
        title: 'Add Aircraft',
        fields: [
          DialogFormField(
            label: 'Model',
            placeholder: 'Enter aircraft model',
            controller: modelController,
          ),
          DialogFormField(
            label: 'Seats',
            placeholder: 'Enter seat numbers (comma separated)',
            controller: seatsController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Seats are required';
              }
              // // Validate comma-separated numbers
              // final seats = value.split(',').map((s) => s.trim());

              // for (final seat in seats) {
              //   if (int.tryParse(seat) == null) {
              //     return 'Please enter valid numbers separated by commas';
              //   }
              // }
              return null;
            },
          ),
        ],
        onSubmit: (values) {
          final seats = values['Seats']!
              .split(',')
              .map((s) => int.parse(s.trim().toUpperCase()))
              .toList();

          context.read<AircraftBloc>().add(
                AddAircraftModel(
                  aircraftModel: AircraftModel(
                    model: values['Model']!,
                    seats: seats.map((e) => e.toString()).toList(),
                  ),
                ),
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isSmallScreen = constraints.maxWidth < 600;
                return Row(
                  children: [
                    Expanded(
                      child: SearchField(
                        hintText: 'Search by model or registration...',
                        controller: _searchController,
                        onChanged: (value) {
                          context
                              .read<AircraftBloc>()
                              .add(SearchAircraft(value));
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (!isSmallScreen)
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton.icon(
                            onPressed: () => _showAddAircraftDialog(context),
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text('Add Aircraft'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C5DD3),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size.fromHeight(40),
                            ),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: ElevatedButton(
                          onPressed: () => _showAddAircraftDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C5DD3),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size(40, 40),
                          ),
                          child: const Icon(Icons.add, size: 20),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            // Table Container
            BlocConsumer<AircraftBloc, AircraftState>(
              listener: (context, state) {
                if (state.message != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message!)),
                  );
                }
                if (state.isLoading == true) {
                  EasyLoading.show();
                } else {
                  EasyLoading.dismiss();
                }
              },
              builder: (context, state) {
                return state.aircraftModels == null
                    ? const SizedBox.shrink()
                    : state.aircraftModels!.isEmpty
                        ? const Center(
                            child: Text('No Aircraft Models Found yet'),
                          )
                        : Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Column(
                                  children: [
                                    // Header
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.withOpacity(0.2),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              'Model',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              'Seats',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                              width: 48), // For remove button
                                        ],
                                      ),
                                    ),
                                    // List
                                    Expanded(
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemCount: state.aircraftModels!.length,
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                                height: 1,
                                                color: Colors.grey
                                                    .withOpacity(0.2)),
                                        itemBuilder: (context, index) {
                                          final aircraft =
                                              state.aircraftModels![index];
                                          return Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    aircraft.model!,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    '[${aircraft.seats!.join(", ")}]',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          ConfirmationDialog(
                                                        message:
                                                            'Are you sure you want to delete this aircraft? This action cannot be undone.',
                                                        onConfirm: () {
                                                          context
                                                              .read<
                                                                  AircraftBloc>()
                                                              .add(DeleteAircraftModel(
                                                                  id: aircraft
                                                                      .id!));
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.red[400],
                                                    size: 20,
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // Footer
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: Colors.grey.withOpacity(0.2),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              // TODO: Implement previous page
                                            },
                                            style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                            ),
                                            child: Text(
                                              'Previous',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF6C5DD3),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              '1',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            child: Text(
                                              '2',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          TextButton(
                                            onPressed: () {
                                              // TODO: Implement next page
                                            },
                                            style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                            ),
                                            child: Text(
                                              'Next',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
              },
            ),
          ],
        ),
      ),
    );
  }
}
