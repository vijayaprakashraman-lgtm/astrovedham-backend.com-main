enum OrderStatus { PENDING, SUCCESS, CANCELLED }

class OrderModel {
  final String id;
  final String orderNumber;
  final String? customerId;
  final String? serviceId;
  final String serviceName;
  final String horoscopeType;
  final String horoscopeTitle;
  final String customerName;
  final String? customerPhone;
  final String? customerEmail;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final double amount;
  final String currency;
  final double? originalPrice;
  final OrderStatus status;
  final bool resultAvailable;
  final String? pdfPath;
  final String? pdfUrl;
  final String? fileurl;
  final String? cancellationReason;
  final Map<String, dynamic>? inputDetails;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    this.customerId,
    this.serviceId,
    required this.serviceName,
    required this.horoscopeType,
    required this.horoscopeTitle,
    required this.customerName,
    this.customerPhone,
    this.customerEmail,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.cancelledAt,
    required this.amount,
    this.currency = 'INR',
    this.originalPrice,
    required this.status,
    this.resultAvailable = false,
    this.pdfPath,
    this.pdfUrl,
    this.fileurl,
    this.cancellationReason,
    this.inputDetails,
  });

  OrderModel copyWith({
    String? id,
    String? orderNumber,
    String? customerId,
    String? serviceId,
    String? serviceName,
    String? horoscopeType,
    String? horoscopeTitle,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    double? amount,
    String? currency,
    double? originalPrice,
    OrderStatus? status,
    bool? resultAvailable,
    String? pdfPath,
    String? pdfUrl,
    String? fileurl,
    String? cancellationReason,
    Map<String, dynamic>? inputDetails,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      customerId: customerId ?? this.customerId,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      horoscopeType: horoscopeType ?? this.horoscopeType,
      horoscopeTitle: horoscopeTitle ?? this.horoscopeTitle,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      originalPrice: originalPrice ?? this.originalPrice,
      status: status ?? this.status,
      resultAvailable: resultAvailable ?? this.resultAvailable,
      pdfPath: pdfPath ?? this.pdfPath,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      fileurl: fileurl ?? this.fileurl,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      inputDetails: inputDetails ?? this.inputDetails,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'customerId': customerId,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'horoscopeType': horoscopeType,
      'horoscopeTitle': horoscopeTitle,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'amount': amount,
      'currency': currency,
      'originalPrice': originalPrice,
      'status': status.name,
      'resultAvailable': resultAvailable,
      'pdfPath': pdfPath,
      'pdfUrl': pdfUrl,
      'fileurl': fileurl,
      'cancellationReason': cancellationReason,
      'inputDetails': inputDetails,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final String id = _stringValue(json['_id']) ??
        _stringValue(json['order_id']) ??
        _stringValue(json['id']) ??
        _stringValue(json['orderNumber']) ??
        '';

    final String orderNumber = _stringValue(json['order_id']) ??
        _stringValue(json['_id']) ??
        _stringValue(json['orderNumber']) ??
        id;

    String customerName = _stringValue(json['name']) ??
        _stringValue(json['customerName']) ??
        'Customer';

    String? customerPhone = _stringValue(json['mobile']) ??
        _stringValue(json['customerPhone']) ??
        _stringValue(json['phone']);

    String? customerEmail = _stringValue(json['emailid']) ??
        _stringValue(json['email']) ??
        _stringValue(json['customerEmail']);

    String? customerId = _stringValue(json['cus_id']) ??
        _stringValue(json['customerId']);

    final customerData = json['customer'];
    if (customerData is Map) {
      customerName = _stringValue(customerData['name']) ?? customerName;
      customerPhone = _stringValue(customerData['phone']) ??
          _stringValue(customerData['mobile']) ??
          customerPhone;
      customerEmail = _stringValue(customerData['email']) ?? customerEmail;
      customerId = _stringValue(customerData['id']) ??
          _stringValue(customerData['_id']) ??
          customerId;
    }

    final createdAt = _parseDate(json['created_at']) ??
        _parseDate(json['createdAt']) ??
        DateTime.now();

    final updatedAt = _parseDate(json['updated_at']) ??
        _parseDate(json['updatedAt']) ??
        createdAt;

    final completedAt = _parseDate(json['completed_at']) ??
        _parseDate(json['completedAt']);

    final cancelledAt = _parseDate(json['cancelled_at']) ??
        _parseDate(json['cancelledAt']);

    final horoscopeType = _stringValue(json['horoscope_type']) ??
        _stringValue(json['horoscopeType']) ??
        '';

    String serviceName = _stringValue(json['serviceName']) ??
        _stringValue(json['horoscopeTitle']) ??
        _stringValue(json['plan_name']) ??
        horoscopeType;

    if (serviceName.isEmpty) serviceName = 'Horoscope Report';

    double amount = 0.0;
    final amountValue = json['amount'] ?? json['order_amount'] ?? json['final_amount'];
    if (amountValue is num) {
      amount = amountValue.toDouble();
    } else if (amountValue is String) {
      amount = double.tryParse(amountValue) ?? 0.0;
    }

    double? originalPrice;
    final originalPriceValue = json['originalPrice'];
    if (originalPriceValue is num) {
      originalPrice = originalPriceValue.toDouble();
    } else if (originalPriceValue is String) {
      originalPrice = double.tryParse(originalPriceValue);
    }

    final OrderStatus status = _parseStatus(_stringValue(json['status']));

    final String? fileurl = _stringValue(json['fileurl']);
    String? pdfUrl = _stringValue(json['pdfUrl']);

    if ((pdfUrl == null || pdfUrl.isEmpty) && fileurl != null && fileurl.isNotEmpty) {
      if (fileurl.startsWith('http://') || fileurl.startsWith('https://')) {
        pdfUrl = fileurl;
      } else {
        pdfUrl = 'https://astrovedham.com/viewhoroscope/$fileurl';
      }
    }

    final bool resultAvailable = status == OrderStatus.SUCCESS &&
        (pdfUrl != null && pdfUrl.isNotEmpty);

    Map<String, dynamic>? inputDetails;
    final inputData = json['inputDetails'];
    if (inputData is Map) {
      inputDetails = Map<String, dynamic>.from(inputData);
    } else {
      inputDetails = {
        if (json['gender'] != null) 'gender': json['gender'],
        if (json['dob'] != null) 'dob': json['dob'],
        if (json['tob'] != null) 'tob': json['tob'],
        if (json['place'] != null) 'place': json['place'],
        if (json['fname'] != null) 'fname': json['fname'],
        if (json['fdob'] != null) 'fdob': json['fdob'],
        if (json['ftob'] != null) 'ftob': json['ftob'],
        if (json['fplace'] != null) 'fplace': json['fplace'],
      };
    }

    return OrderModel(
      id: id,
      orderNumber: orderNumber,
      customerId: customerId,
      serviceId: _stringValue(json['serviceId']) ?? _stringValue(json['plan_id']),
      serviceName: serviceName,
      horoscopeType: horoscopeType,
      horoscopeTitle: serviceName,
      customerName: customerName,
      customerPhone: customerPhone,
      customerEmail: customerEmail,
      createdAt: createdAt,
      updatedAt: updatedAt,
      completedAt: completedAt,
      cancelledAt: cancelledAt,
      amount: amount,
      currency: _stringValue(json['currency']) ?? 'INR',
      originalPrice: originalPrice,
      status: status,
      resultAvailable: resultAvailable,
      pdfPath: _stringValue(json['pdfPath']),
      pdfUrl: pdfUrl,
      fileurl: fileurl,
      cancellationReason: _stringValue(json['cancellationReason']),
      inputDetails: inputDetails,
    );
  }

  static String? _stringValue(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static OrderStatus _parseStatus(String? status) {
    if (status == null || status.isEmpty) {
      return OrderStatus.PENDING;
    }

    final s = status.toUpperCase();
    if (s == 'COMPLETED' || s == 'SUCCESS' || s == 'PAID' || s == 'ACTIVE') {
      return OrderStatus.SUCCESS;
    } else if (s == 'CANCELLED' || s == 'FAILED' || s == 'EXPIRED') {
      return OrderStatus.CANCELLED;
    } else {
      return OrderStatus.PENDING;
    }
  }
}
