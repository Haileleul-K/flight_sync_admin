import 'package:flight_sync_admin/core/constants/responses.dart';
import 'package:flight_sync_admin/core/widgets/add_item_dialog.dart';
import 'package:flight_sync_admin/core/widgets/confirmation_dialog.dart';
import 'package:flight_sync_admin/core/widgets/search_field.dart';
import 'package:flight_sync_admin/features/rl_level/bloc/rl_level_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RLLevelPage extends StatefulWidget {
  const RLLevelPage({super.key});

  @override
  State<RLLevelPage> createState() => _RLLevelPageState();
}

class _RLLevelPageState extends State<RLLevelPage> {

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddDutyPositionDialog(BuildContext context) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AddItemDialog(
        title: 'Add RL Level',
        fields: [
          DialogFormField(
            label: 'Name',
            placeholder: 'Enter RL level name',
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'RL level name is required';
              }

              return null;
            },
          ),
        ],
        onSubmit: (values) {
          context.read<RlLevelBloc>().add(
                AddRlLevel(
                  rlLevel: RlLevel(
                    level: values['Name']!,
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
                        hintText: 'Search RL Levels...',
                        controller: _searchController,
                        onChanged: (value) {
                          context.read<RlLevelBloc>().add(SearchRlLevel(query: value));
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
                            label: const Text('Add RL Level'),
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
            BlocConsumer<RlLevelBloc, RlLevelState>(
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
                return state.rlLevels == null
                    ? const SizedBox.shrink()
                    : state.rlLevels!.isEmpty
                        ? const Center(
                            child: Text('No RL levels found'),
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
                                              'Level',
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
                                        itemCount: state.rlLevels!.length,
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                          height: 1,
                                          color: Colors.grey.withOpacity(0.2),
                                        ),
                                        itemBuilder: (context, index) {
                                          final level = state.rlLevels![index];
                                          return Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    level.level!,
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
                                                            'Are you sure you want to delete ${level.level}?',
                                                        onConfirm: () {
                                                          context
                                                              .read<
                                                                  RlLevelBloc>()
                                                              .add(DeleteRlLevel(
                                                                  id: level
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
