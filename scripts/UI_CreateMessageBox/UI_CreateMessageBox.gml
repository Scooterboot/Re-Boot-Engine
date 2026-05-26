function UI_CreateMessageBox(header,description,messageType)
{
	var mbox = instance_create_depth(0,0,1,obj_UI_MessageBox);
	mbox.header_raw = header;
	mbox.description_raw = description;
	mbox.messageType = messageType;
}
