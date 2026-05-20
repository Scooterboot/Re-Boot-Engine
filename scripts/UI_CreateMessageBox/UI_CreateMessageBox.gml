function UI_CreateMessageBox(header,description,messageType)
{
	var mbox = instance_create_depth(0,0,1,obj_MessageBox);
	mbox.header = header;
	mbox.description = description;
	mbox.messageType = messageType;
}
