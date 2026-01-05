class GoToItem {
   String? id;
   String? identifier;
   String? title;
   String? iconSource;
   String? color;
   String? targetPage;
   Type? targetType;
   bool showInList;
   bool isModal;
   bool? topNavigation;
   bool openExternal;
   String? url;
   Function? action;
   String? goToSection;
   int? count;
   String? targetPageFlutter;
   String? iconSourceFlutter;

  GoToItem({
     this.id,
     this.identifier,
     this.title,
     this.iconSource,
     this.color,
     this.targetPage,
     this.targetType,
    this.showInList = true,
    this.isModal = false,
    this.topNavigation = false,
    this.openExternal = false,
    this.url,
    this.action,
    this.goToSection,
    this.count,
    this.targetPageFlutter,
    this.iconSourceFlutter = ''
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Identifier'] = identifier;
    data['Title'] = title;
    data['IconSource'] = iconSource;
    data['Color'] = color;
    data['TargetPage'] = targetPage;
   // data['TargetType'] = targetType.toString();
    data['ShowInList'] = showInList;
    data['IsModal'] = isModal;
    data['TopNavigation'] = topNavigation;
    data['OpenExternal'] = openExternal;
    data['URL'] = url;
    data['GoToSection'] = goToSection;
    data['Count'] = count;
    data['TargetPageFlutter'] = targetPageFlutter;
    data['IconSourceFlutter'] = iconSourceFlutter;
    return data;
  }

   factory GoToItem.fromJson(Map<String, dynamic> json) {
    return GoToItem(
      id: json['Id'],
      identifier: json['Identifier'],
      title: json['Title'],
      iconSource: json['IconSource'],
      color: json['Color'],
      targetPage: json['TargetPage'],
     // targetType: Type.fromString(json['TargetType']),
      showInList: json['ShowInList'],
      isModal: json['IsModal'],
      topNavigation: json['TopNavigation'],
      openExternal: json['OpenExternal'],
      url: json['URL'],
      goToSection: json['GoToSection'],
      count: json['Count'],
      targetPageFlutter: json['TargetPageFlutter'],
      iconSourceFlutter: json['IconSourceFlutter']
    );
  }
}