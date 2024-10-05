import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Để định dạng ngày tháng

class MedicineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 50.0), // Thêm khoảng cách ở trên
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thuốc của tôi',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 40.0, // Đặt chiều rộng của hình tròn
                    height: 40.0, // Đặt chiều cao của hình tròn
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 201, 195, 195), // Màu nền của hình tròn
                    ),
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {}, 
                      icon: Icon(
                        Icons.add, 
                        color: Colors.white, // Màu biểu tượng
                        size: 20.0, // Kích thước biểu tượng
                      ),
                      padding: EdgeInsets.zero, // Xóa padding để biểu tượng nằm chính giữa
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),

            // DateSlider được đặt trực tiếp trong cột
            DateSlider(),
            SizedBox(height: 8.0), // Khoảng cách giữa thanh trượt và dòng chữ

            // Dòng chữ "Hôm nay"
            Center(
              child: TodayText(),
            ),

            // Container cuộn cho thuốc hoặc thông báo không có thuốc
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16.0), // Khoảng cách bên trong
                  child: Center(
                    child: MedicationList(),
                  ),
                ),
              ),
            ),

            // Nút chỉnh sửa hộp thuốc
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Thêm hành động của nút ở đây
                },
                icon: Icon(Icons.edit), // Biểu tượng cho nút
                label: Text('Chỉnh sửa hộp thuốc'), // Văn bản cho nút
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // Đặt kích thước tối thiểu
                  textStyle: TextStyle(fontSize: 16), // Kích thước chữ
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodayText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now(); // Lấy ngày hôm nay
    return Text(
      'Hôm nay, ${DateFormat('d MMMM yyyy').format(today)}', // Ngày tháng hiện tại
      style: TextStyle(
        color: Colors.red, // Màu chữ
        fontSize: 16.0, // Kích thước chữ
      ),
    );
  }
}

class MedicationList extends StatelessWidget {
  final List<String> medications = []; // Danh sách thuốc (hiện tại rỗng)

  @override
  Widget build(BuildContext context) {
    if (medications.isEmpty) {
      // Hiển thị thông báo nếu không có thuốc
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_box.png', // Đường dẫn tới hình ảnh hộp giấy trống
            height: 100.0, // Chiều cao của hình ảnh
            width: 100.0, // Chiều rộng của hình ảnh
          ),
          SizedBox(height: 16.0), // Khoảng cách giữa hình ảnh và văn bản
          Text(
            'Hiện không có thuốc đặt lịch',
            style: TextStyle(fontSize: 16.0, color: Colors.grey), // Màu chữ
          ),
        ],
      );
    } else {
      // Nếu có thuốc, hiển thị danh sách thuốc
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: medications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(medications[index]), // Hiển thị tên thuốc
          );
        },
      );
    }
  }
}

class DateSlider extends StatefulWidget {
  @override
  _DateSliderState createState() => _DateSliderState();
}

class _DateSliderState extends State<DateSlider> {
  final DateTime today = DateTime.now(); // Lấy ngày hôm nay
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Cuộn đến ngày hôm nay khi màn hình được xây dựng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  void _scrollToToday() {
    // Tính toán chỉ số của ngày hôm nay trong danh sách
    int todayIndex = 4; // Chỉ số cho ngày hôm nay (ở giữa danh sách 21 ngày)
    _scrollController.jumpTo(todayIndex * 60.0); // Cuộn đến vị trí cần thiết (60 là chiều rộng của hộp)
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0, // Đặt chiều cao cố định cho thanh trượt ngày
      child: ListView.builder(
        controller: _scrollController, // Thêm ScrollController
        scrollDirection: Axis.horizontal,
        itemCount: 21, // Hiển thị 21 ngày (7 trước, 7 sau, và tuần hiện tại)
        itemBuilder: (context, index) {
          DateTime date = today.add(Duration(days: index - 7)); // Dịch chuyển -7 để bắt đầu 1 tuần trước hôm nay
          
          // Kiểm tra xem ngày hiện tại có khớp với ngày hôm nay không
          bool isToday = date.isAtSameMomentAs(today);

          String dayOfWeek = DateFormat('EEE').format(date); // Ngày trong tuần (Thứ hai, Thứ ba, v.v.)
          String dayOfMonth = DateFormat('d').format(date); // Ngày trong tháng (1, 2, 3, v.v.)
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: isToday // Kiểm tra nếu là ngày hôm nay
                ? Container(
                    width: 60.0, // Đặt chiều rộng của hộp
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Màu nền nếu là hôm nay
                      border: Border.all(color: Colors.grey), // Đường viền màu xám
                      borderRadius: BorderRadius.circular(8.0), // Bo góc hộp
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40.0, // Đặt chiều rộng của vòng tròn
                          height: 40.0, // Đặt chiều cao của vòng tròn
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black, // Màu nền của vòng tròn
                            border: Border.all(color: Colors.grey), // Đường viền
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            dayOfMonth, // Hiển thị ngày trong tháng
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white, // Màu chữ trong vòng tròn
                            ),
                          ),
                        ),
                        SizedBox(height: 4.0), // Khoảng cách giữa vòng tròn và ngày trong tuần
                        Text(
                          dayOfWeek, // Hiển thị ngày trong tuần
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey, // Màu chữ ngày trong tuần
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40.0, // Đặt chiều rộng của vòng tròn
                        height: 40.0, // Đặt chiều cao của vòng tròn
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent, // Màu nền không phải hôm nay
                          border: Border.all(color: Colors.grey), // Đường viền
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          dayOfMonth, // Hiển thị ngày trong tháng
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black, // Màu chữ không phải hôm nay
                          ),
                        ),
                      ),
                      SizedBox(height: 4.0), // Khoảng cách giữa vòng tròn và ngày trong tuần
                      Text(
                        dayOfWeek, // Hiển thị ngày trong tuần
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey, // Màu chữ ngày trong tuần
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: MedicineScreen()));
}
