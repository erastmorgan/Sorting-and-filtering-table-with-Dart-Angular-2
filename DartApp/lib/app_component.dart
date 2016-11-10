import 'dart:collection';
import 'dart:convert';
import 'dart:html';

import 'package:DartApp/helpers/user_serializer.dart';
import 'package:DartApp/models/user.dart';
import 'package:angular2/core.dart';

@Component(
    selector: 'my-app',
    template: '''
    <div class="container">
    <div class="pull-left" style="width: 200px; padding-right: 20px;">
      <h2>Filtering</h2>
      <div class="panel panel-default">
      <div class="panel-body">
        <div>
          <b>
            Gender
          </b>
        </div>
        <div class="checkbox" style="padding-left: 10px;" *ngFor="let item of filters[\'gender\']; let i = index">
          <label><input [checked]="item[2]" id="filter_gender_{{i}}" class="filter" (change)="checkFilter()" type="checkbox" value="{{item[0]}}">
            {{item[0]}} ({{item[1]}})
          </label>
        </div>
        <div>
          <b>
            Department
          </b>
        </div>
        <div class="checkbox" style="padding-left: 10px;" *ngFor="let item of filters[\'department\']; let i = index">
          <label><input [checked]="item[2]" id="filter_department_{{i}}" class="filter" (change)="checkFilter()" type="checkbox" value="{{item[0]}}">
            {{item[0]}} ({{item[1]}})
          </label>
        </div>
        <div>
          <b>
            City
          </b>
        </div>
        <div class="checkbox" style="padding-left: 10px;" *ngFor="let item of filters[\'city\']; let i = index">
          <label><input [checked]="item[2]" id="filter_city_{{i}}" class="filter" (change)="checkFilter()" type="checkbox" value="{{item[0]}}">
            {{item[0]}} ({{item[1]}})
          </label>
        </div>
      </div>
    </div>
    </div>
    <div class="pull-left">
    <td>
      <table class="table table-striped table-sortable table-bordered">
        <thead>
          <tr style="cursor: pointer;">
            <th (click)="sort('name')">Name <i id="img_name" class="fa fa-fw fa-sort"></i></th>
            <th (click)="sort('age')">Age <i id="img_age" class="fa fa-fw fa-sort"></i></th>
            <th (click)="sort('gender')">Gender <i id="img_gender" class="fa fa-fw fa-sort"></i></th>
            <th (click)="sort('department')">Department <i id="img_department" class="fa fa-fw fa-sort"></i></th>
            <th (click)="sort('address')">Address <i id="img_address" class="fa fa-fw fa-sort"></i></th>
          </tr>
        </thead>
        <tbody>
          <tr *ngFor="let u of users">
            <td>{{u.name}}</td>
            <td>{{u.age}}</td>
            <td>{{u.gender}}</td>
            <td>{{u.department}}</td>
            <td>{{u.address.toString()}}</td>
          </tr>
        </tbody>
      </table>
      </div>
    </div>''')
class AppComponent {
  static var mapUsers = new List<Map>();
  static var currentUsers = new List<User>();

  var sortValues = new LinkedHashMap<String, int>();
  static var filtersMap = new LinkedHashMap<String, List<List<dynamic>>>();
  var sortField = 'name';

  get users {
    return currentUsers;
  }

  get filters {
    return filtersMap;
  }

  static var url =
      'https://gist.githubusercontent.com/bunopus/f48fbb06578003fb521c7c1a54fd906a/raw/e5767c1e7f172c6375f064a9441f2edd57a79f15/test_users.json';
  var request = HttpRequest.getString(url).then(setBase);

  static void setBase(String responseStr) {
    mapUsers = JSON.decode(responseStr);
    currentUsers = UserSerializer.Deserialize(mapUsers);
    setFilter();
  }

  void checkFilter() {
    var filterList = querySelectorAll('.filter').where((x) => x.checked);
    currentUsers = UserSerializer.Deserialize(mapUsers);
    if (filterList.length > 0) {
      for (var item in filterList) {
        if (item.id.contains('filter_gender')) {
          currentUsers =
              currentUsers.where((x) => x.gender == item.value).toList();
        } else if (item.id.contains('filter_department')) {
          currentUsers =
              currentUsers.where((x) => x.department == item.value).toList();
        } else if (item.id.contains('filter_city')) {
          currentUsers =
              currentUsers.where((x) => x.address.city == item.value).toList();
        }
      }
    }

    setFilter();
    setFiltersChange();
    if (sortValues[sortField] != null && sortValues[sortField] != 0)
      sortValues[sortField] = -sortValues[sortField];

    sort(sortField);
  }

  void setFiltersChange() {
    var filterList = querySelectorAll('.filter');
    for (var item in filterList) {
      if (item.id.contains('filter_gender')) {
        for (var i = 0; i < filtersMap['gender'].length; i++) {
          if (filtersMap['gender'][i][0] == item.value) {
            filtersMap['gender'][i][2] = item.checked;
            break;
          }
        }
      } else if (item.id.contains('filter_department')) {
        for (var i = 0; i < filtersMap['department'].length; i++) {
          if (filtersMap['department'][i][0] == item.value) {
            filtersMap['department'][i][2] = item.checked;
            break;
          }
        }
      } else if (item.id.contains('filter_city')) {
        for (var i = 0; i < filtersMap['city'].length; i++) {
          if (filtersMap['city'][i][0] == item.value) {
            filtersMap['city'][i][2] = item.checked;
            break;
          }
        }
      }
    }
  }

  void sort(var field) {
    sortField = field;
    if (sortValues[field] == null) sortValues[field] = 0;

    sortValues[field] == 0 || sortValues[field] == -1
        ? sortValues[field] = 1
        : sortValues[field] = -1;
    for (var key in sortValues.keys) {
      if (key != field) {
        sortValues[key] = 0;
        setSortImg(0, key);
      }
    }

    setSortImg(sortValues[field], field);
    switch (field) {
      case 'name':
        sortValues[field] == 0 || sortValues[field] == -1
            ? currentUsers.sort((a, b) => a.name.compareTo(b.name))
            : currentUsers.sort((a, b) => b.name.compareTo(a.name));
        break;

      case 'age':
        sortValues[field] == 0 || sortValues[field] == -1
            ? currentUsers.sort((a, b) => a.age.compareTo(b.age))
            : currentUsers.sort((a, b) => b.age.compareTo(a.age));

        break;

      case 'gender':
        sortValues[field] == 0 || sortValues[field] == -1
            ? currentUsers.sort((a, b) => a.gender.compareTo(b.gender))
            : currentUsers.sort((a, b) => b.gender.compareTo(a.gender));
        break;

      case 'department':
        sortValues[field] == 0 || sortValues[field] == -1
            ? currentUsers.sort((a, b) => a.department.compareTo(b.department))
            : currentUsers.sort((a, b) => b.department.compareTo(a.department));
        break;

      case 'address':
        sortValues[field] == 0 || sortValues[field] == -1
            ? currentUsers.sort(
                (a, b) => a.address.toString().compareTo(b.address.toString()))
            : currentUsers.sort(
                (a, b) => b.address.toString().compareTo(a.address.toString()));
        break;
    }
  }

  void setSortImg(var sortValue, var field) {
    var element = querySelector('#img_' + field);
    if (sortValue == 0) {
      element.classes.remove('fa-sort-asc');
      element.classes.remove('fa-sort-desc');
    } else if (sortValue == -1) {
      element.classes.remove('fa-sort-desc');
      element.classes.add('fa-sort-asc');
    } else if (sortValue == 1) {
      element.classes.add('fa-sort-desc');
      element.classes.remove('fa-sort-asc');
    }
  }

  static void setFilter() {
    for (var filterName in ['gender', 'department', 'city']) {
      var uniques = new LinkedHashMap<String, int>();
      for (var user in currentUsers) {
        switch (filterName) {
          case 'gender':
            if (uniques[user.gender] == null) uniques[user.gender] = 0;

            uniques[user.gender] += 1;
            break;

          case 'department':
            if (uniques[user.department] == null) uniques[user.department] = 0;

            uniques[user.department] += 1;
            break;

          case 'city':
            if (uniques[user.address.city] == null)
              uniques[user.address.city] = 0;

            uniques[user.address.city] += 1;
            break;
        }
      }

      var result = new List<List<dynamic>>();
      for (var item in uniques.keys) {
        result.add([item, uniques[item], false]);
      }

      result.sort((a, b) => a[0].compareTo(b[0]));
      filtersMap[filterName] = result;
    }
  }
}
