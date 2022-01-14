import 'package:dazle/domain/entities/message.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:dazle/domain/repositories/message_repository.dart';

class DataMessageRepository extends MessageRepository {
  List<Message> messageListings;
  List<Message> messageLeads;

  static DataMessageRepository _instance = DataMessageRepository._internal();
  DataMessageRepository._internal() {
    messageListings = <Message>[];
    messageLeads = <Message>[];
  }
  factory DataMessageRepository() => _instance;

  @override
  Future<List<Message>> getMessageLeads() async {
    return [
      Message(
        avatarURL: 'https://robohash.org/set_set3/2',
        message: 'Hello, Good Morning.',
        messageType: 'text',
        timeAgo: '1m ago',
        sender: User(
          id: '2',
          firstName: 'qwe',
          lastName: 'asd',
          email: 'zxc@gmail.com',
          mobileNumber: '987654321',
          brokerLicenseNumber: '1234',
          position: 'Broker',
          aboutMe: '...',
        ),
        property: Property(
          coverPhoto: 'https://picsum.photos/id/55/200/300',
          photos: [
            'https://picsum.photos/id/56/200/300',
            'https://picsum.photos/id/57/200/300',
            'https://picsum.photos/id/58/200/300',
          ],
          keywords: ['aa', 'ss'],
          price: '540,735.12',
          totalBedRoom: '213',
          totalBathRoom: '321',
          totalParkingSpace: '22',
          totalArea: '432',
          district: 'Lapasan',
          city: 'Cagayan de Oro City',
          amenities: ['Shared Gym','Covered Parking','Central AC'],
          isYourProperty: 'unfurnished',
          timePeriod: 'month',
          description: "Property Description: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"
        )
      )
    ];
  }

  @override
  Future<List<Message>> getMessageListings() async {
    return [
      Message(
        avatarURL: 'https://robohash.org/set_set3/1',
        message: 'Hi, how are you?',
        messageType: 'text',
        timeAgo: '1d ago',
        sender: User(
          id: '1',
          firstName: 'first',
          lastName: 'last',
          email: 'email@gmail.com',
          mobileNumber: '123456789',
          brokerLicenseNumber: '1234',
          position: 'Salesperson',
          aboutMe: 'about me',
        ),
        property: Property(
          coverPhoto: 'https://picsum.photos/id/51/200/300',
          photos: [
            'https://picsum.photos/id/52/200/300',
            'https://picsum.photos/id/53/200/300',
            'https://picsum.photos/id/54/200/300',
          ],
          keywords: ['qq', 'ww'],
          price: '664,321.12',
          totalBedRoom: '11',
          totalBathRoom: '22',
          totalParkingSpace: '33',
          totalArea: '64',
          district: 'Lapasan',
          city: 'Cagayan de Oro City',
          amenities: ['Kitchen','Wifi','Eco Friendly','Security'],
          isYourProperty: 'furnished',
          timePeriod: 'year',
          description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        )
      )
    ];
  }
  
}