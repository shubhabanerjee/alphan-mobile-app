class HomePageDataModel {
  int? ack;
  int? status;
  String? message;
  List<ResponseData>? responseData;

  HomePageDataModel({this.ack, this.status, this.message, this.responseData});

  HomePageDataModel.fromJson(Map<String, dynamic> json) {
    ack = json['ack'];
    status = json['status'];
    message = json['message'];
    if (json['responseData'] != null) {
      responseData = <ResponseData>[];
      json['responseData'].forEach((v) {
        responseData!.add(new ResponseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ack'] = this.ack;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.responseData != null) {
      data['responseData'] = this.responseData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResponseData {
  String? sId;
  String? sV;
  String? content;
  String? createdAt;
  String? defaultImage;
  String? shortDescription;
  String? slug;
  String? status;
  String? title;
  String? updatedAt;
  List<UserLikes>? userLikes;
  List? isLiked;
  int? totalLikes;
  List? userComment;
  int? totalComments;

  ResponseData(
      {this.sId,
      this.sV,
      this.content,
      this.createdAt,
      this.defaultImage,
      this.shortDescription,
      this.slug,
      this.status,
      this.title,
      this.updatedAt,
      this.userLikes,
      this.isLiked,
      this.totalLikes,
      this.userComment,
      this.totalComments});

  ResponseData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sV = json['__v'].toString();
    content = json['content'];
    createdAt = json['createdAt'];
    defaultImage = json['defaultImage'];
    shortDescription = json['shortDescription'];
    slug = json['slug'];
    status = json['status'];
    title = json['title'];
    updatedAt = json['updatedAt'];
    if (json['user_likes'] != null) {
      userLikes = <UserLikes>[];
      json['user_likes'].forEach((v) {
        userLikes!.add(new UserLikes.fromJson(v));
      });
    }
    if (json['isLiked'] != null) {
      isLiked = <Null>[];
      json['isLiked'].forEach((v) {
        isLiked!.add(v);
      });
    }
    totalLikes = json['totalLikes'];
    if (json['user_comment'] != null) {
      userComment = <Null>[];
      json['user_comment'].forEach((v) {
        userComment!.add((v));
      });
    }
    totalComments = json['totalComments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['__v'] = this.sV;
    data['content'] = this.content;
    data['createdAt'] = this.createdAt;
    data['defaultImage'] = this.defaultImage;
    data['shortDescription'] = this.shortDescription;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['title'] = this.title;
    data['updatedAt'] = this.updatedAt;
    if (this.userLikes != null) {
      data['user_likes'] = this.userLikes!.map((v) => v.toJson()).toList();
    }
    if (this.isLiked != null) {
      data['isLiked'] = this.isLiked!.map((v) => v.toJson()).toList();
    }
    data['totalLikes'] = this.totalLikes;
    if (this.userComment != null) {
      data['user_comment'] = this.userComment!.map((v) => v.toJson()).toList();
    }
    data['totalComments'] = this.totalComments;
    return data;
  }
}

class UserLikes {
  String? sId;
  String? sV;
  String? createdAt;
  String? isLike;
  String? referenceNewsId;
  String? referenceUserId;
  String? status;
  String? updatedAt;

  UserLikes(
      {this.sId,
      this.sV,
      this.createdAt,
      this.isLike,
      this.referenceNewsId,
      this.referenceUserId,
      this.status,
      this.updatedAt});

  UserLikes.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sV = json['__v'].toString();
    createdAt = json['createdAt'];
    isLike = json['isLike'].toString();
    referenceNewsId = json['referenceNewsId'];
    referenceUserId = json['referenceUserId'];
    status = json['status'].toString();
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['__v'] = this.sV;
    data['createdAt'] = this.createdAt;
    data['isLike'] = this.isLike;
    data['referenceNewsId'] = this.referenceNewsId;
    data['referenceUserId'] = this.referenceUserId;
    data['status'] = this.status;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
