import 'package:flight_sync_admin/core/widgets/add_item_dialog.dart';
import 'package:flight_sync_admin/core/widgets/confirmation_dialog.dart';
import 'package:flight_sync_admin/core/widgets/search_field.dart';
import 'package:flight_sync_admin/features/duty_position/bloc/duty_position_bloc.dart';
import 'package:flight_sync_admin/core/constants/responses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DutyPositionPage extends StatefulWidget {
 

  const DutyPositionPage({super.key});

  @override
  State<DutyPositionPage> createState() => _DutyPositionPageState();
}

class _DutyPositionPageState extends State<DutyPositionPage> {

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  void _showAddDutyPositionDialog(BuildContext context) {
    final codeController = TextEditingController();
    final labelController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AddItemDialog(
        title: 'Add Duty Position',
        fields: [
          DialogFormField(
            label: 'Code',
            placeholder: 'Enter duty position code',
            controller: codeController,
          ),
          DialogFormField(
            label: 'Label',
            placeholder: 'Enter duty position label',
            controller: labelController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Label is required';
              }

              return null;
            },
          ),
        ],
        onSubmit: (values) {
          context.read<DutyPositionBloc>().add(
                AddDutyPosition(
                  dutyPosition: DutyPosition(
                    code: values['Code']!,
                    label: values['Label']!,
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
                      child:SearchField(
                    hintText: 'Search duty position...',
                    controller: _searchController,
                    onChanged: (value) {
                      debugPrint(value);
                      context.read<DutyPositionBloc>().add(SearchDutyPosition(value));
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
                            onPressed: () {
                              _showAddDutyPositionDialog(context);
                            },
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text('Add Duty Position'),
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
                          onPressed: () {
                            _showAddDutyPositionDialog(context);
                          },
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
            BlocConsumer<DutyPositionBloc, DutyPositionState>(
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
                return state.dutyPositions == null
                    ? const SizedBox.shrink()
                    : state.dutyPositions!.isEmpty
                        ? const Center(
                            child: Text('No duty positions found'),
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
                                              'Code',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              'Label',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 48),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemCount: state.dutyPositions!.length,
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                          height: 1,
                                          color: Colors.grey.withOpacity(0.2),
                                        ),
                                        itemBuilder: (context, index) {
                                          final position =
                                              state.dutyPositions![index];
                                          return Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    position.code!,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    position.label!,
                                                    style: const TextStyle(
                                                      fontSize: 14,
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
                                                            'Are you sure you want to delete this duty position? This action cannot be undone.',
                                                        onConfirm: () {
                                                          context
                                                              .read<
                                                                  DutyPositionBloc>()
                                                              .add(DeleteDutyPosition(
                                                                  id: position
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
