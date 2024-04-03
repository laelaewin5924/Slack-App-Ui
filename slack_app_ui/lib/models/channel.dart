

class Channel {
  int id;
  String channelName;
  int channelStatus;

  Channel({
    required this.id,
    required this.channelName,
    required this.channelStatus,
  });

  factory Channel.fromJson(Map<String , dynamic> json){
    return switch(json) {
    {"id": int id,
    "channel_name": String channelName,
    "channel_status": int channelStatus
    } =>
      Channel(id: id, channelName:channelName, channelStatus:channelStatus),
    _ => throw const FormatException("Failed to load"),
    };
  }

}