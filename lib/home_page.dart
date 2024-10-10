import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wempro_project/api_service.dart';
import 'data_model.dart';



final dataProvider = FutureProvider<Getdata>((ref) async {
  final apiService = ApiService();
  return apiService.fetchData();
});


final selectedRadioProvider = StateProvider<String?>((ref) => null);
final selectedDropdownProvider = StateProvider<String?>((ref) => null);
final textFieldProvider = StateProvider<String?>((ref) => '');
final checkboxProvider = StateProvider<bool>((ref) => false);


class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var getApiData = ref.read(dataProvider);


    return Scaffold(
      appBar: AppBar(
        title: Text('Wempro Api Data'),
        centerTitle: true,
      ),
      body: getApiData.when(
        data: (getData) {

          return ListView(
            padding: EdgeInsets.all(16),
            children: getData.jsonResponse.attributes.map((attribute) {
              switch (attribute.type) {
                case 'radio':
                  return buildRadioGroup(attribute, ref);
                case 'dropdown':
                  return buildDropdown(attribute, ref);
                case 'textfield':
                  return buildTextField(attribute, ref);
                case 'checkbox':
                  return buildCheckbox(attribute, ref);
                default:
                  return SizedBox.shrink();
              }
            }).toList(),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

Widget buildRadioGroup(Attribute attribute, WidgetRef ref) {
  final selectedRadio = ref.watch(selectedRadioProvider);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(attribute.title, style: TextStyle(fontWeight: FontWeight.bold)),
      ...attribute.options!.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: selectedRadio,
          onChanged: (value) {
            ref.read(selectedRadioProvider.notifier).state = value;
          },
        );
      }).toList(),
    ],
  );
}

Widget buildDropdown(Attribute attribute, WidgetRef ref) {
  final selectedDropdown = ref.watch(selectedDropdownProvider);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(attribute.title, style: TextStyle(fontWeight: FontWeight.bold)),
      DropdownButton<String>(
        value: selectedDropdown,
        items: attribute.options!.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (value) {
          ref.read(selectedDropdownProvider.notifier).state = value;
        },
      ),
    ],
  );
}

Widget buildTextField(Attribute attribute, WidgetRef ref) {
  final textFieldValue = ref.watch(textFieldProvider);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(attribute.title, style: TextStyle(fontWeight: FontWeight.bold)),
      TextFormField(
        initialValue: textFieldValue,
        onChanged: (value) {
          ref.read(textFieldProvider.notifier).state = value;
        },
        decoration: InputDecoration(hintText: "Enter ${attribute.title}"),
      ),
    ],
  );
}

Widget buildCheckbox(Attribute attribute, WidgetRef ref) {
  final selectedCheckbox = ref.watch(checkboxProvider);
  return CheckboxListTile(
    title: Text(attribute.title),
    value: selectedCheckbox,
    onChanged: (value) {
      ref.read(checkboxProvider.notifier).state = value ?? false;
    },
  );
}