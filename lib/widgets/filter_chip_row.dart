import 'package:flutter/material.dart';

class FilterChipRow extends StatelessWidget {
  final List<String> filters;
  final int selectedFilter;
  final ValueChanged<int> onFilterSelected;

  const FilterChipRow({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: List.generate(
              filters.length,
              (index) => _buildFilterChip(
                context,
                filters[index],
                index == selectedFilter,
                index,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    bool selected,
    int index,
  ) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => onFilterSelected(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? const Color(0xffdeeaf5) : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: selected
                    ? const Color(0xffdeeaf5)
                    : const Color(0xFFD7D7D7),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected)
                  const Icon(
                    Icons.check,
                    color: Color.fromARGB(255, 16, 97, 163),
                    size: 18,
                  ),
                if (selected) const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: selected
                        ? const Color.fromARGB(255, 67, 136, 192)
                        : const Color(0xFF222B45),
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
