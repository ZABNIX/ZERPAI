// FILE: lib/modules/items/presentation/sections/composition_section.dart

import 'package:flutter/material.dart';
import '../../models/item_model.dart';

class CompositionSection extends StatefulWidget {
  final Function(List<ItemComposition>) onChanged;

  const CompositionSection({Key? key, required this.onChanged})
    : super(key: key);

  @override
  State<CompositionSection> createState() => _CompositionSectionState();
}

class _CompositionSectionState extends State<CompositionSection> {
  List<ItemComposition> rows = [ItemComposition()];

  void updateRow(int index, ItemComposition updated) {
    rows[index] = updated;
    widget.onChanged(List.from(rows));
    setState(() {});
  }

  void addRow() {
    rows.add(ItemComposition());
    widget.onChanged(List.from(rows));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: const [Text("TRACK ACTIVE INGREDIENTS")]),
            const SizedBox(height: 16),

            // header
            Row(
              children: const [
                Expanded(child: Text("Contents")),
                Expanded(child: Text("Strength")),
                Expanded(child: Text("Unit")),
                Expanded(child: Text("Schedule of content")),
              ],
            ),
            const SizedBox(height: 10),

            Column(
              children: List.generate(rows.length, (i) {
                final row = rows[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          value: row.content,
                          items: const [
                            DropdownMenuItem(
                              value: "Paracetamol",
                              child: Text("Paracetamol"),
                            ),
                            DropdownMenuItem(
                              value: "Ibuprofen",
                              child: Text("Ibuprofen"),
                            ),
                          ],
                          onChanged: (v) =>
                              updateRow(i, row.copyWith(content: v)),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: row.strength,
                          onChanged: (v) =>
                              updateRow(i, row.copyWith(strength: v)),
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonFormField(
                          value: row.unit,
                          items: const [
                            DropdownMenuItem(value: "mg", child: Text("mg")),
                            DropdownMenuItem(value: "ml", child: Text("ml")),
                          ],
                          onChanged: (v) => updateRow(i, row.copyWith(unit: v)),
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonFormField(
                          value: row.schedule,
                          items: const [
                            DropdownMenuItem(value: "H", child: Text("H")),
                            DropdownMenuItem(value: "H1", child: Text("H1")),
                            DropdownMenuItem(
                              value: "Narcotic",
                              child: Text("Narcotic"),
                            ),
                          ],
                          onChanged: (v) =>
                              updateRow(i, row.copyWith(schedule: v)),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),

            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: addRow,
              icon: const Icon(Icons.add),
              label: const Text("Add New"),
            ),
          ],
        ),
      ),
    );
  }
}
