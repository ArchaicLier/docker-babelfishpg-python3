--Update certificate by: python3.9 -m pip install --upgrade certifi
--NOTE: After installing python3-pip certificates updates automatically

--Connect to PostgreSQL>babelfish_db>master_dbo and exec

create extension if not exists plpython3u ;

create or replace function get_json(url_to_json text)
	returns json
as $$
	import urllib.request
	from urllib.error import URLError 
	
	try:
		with urllib.request.urlopen(url_to_json) as json_file:
			return json_file.read().decode('UTF-8')
	except URLError:
		#If certificate dont installed
		import ssl
		with urllib.request.urlopen(url_to_json,context=ssl._create_unverified_context()) as json_file:
			return json_file.read().decode('UTF-8')
$$ language plpython3u;

select * from
	json_each(get_json('https://raw.githubusercontent.com/monkvision/monkjs/181105c64feefbca06a21a3b4021972a560d9f62/packages/sights/package.json'));


create or replace function get_xml(url_to_xml text)
	returns xml
as $$
	import urllib.request
	from urllib.error import URLError 

	try:
		with urllib.request.urlopen(url_to_xml) as xml_file:
			return xml_file.read().decode('UTF-8')
	except URLError:
		#If certificate dont installed
		import ssl
		with urllib.request.urlopen(url_to_xml,context=ssl._create_unverified_context()) as xml_file:
			return xml_file.read().decode('UTF-8')
$$ language plpython3u;

select * from 
	get_xml('https://raw.githubusercontent.com/mgaoling/mpl_dataset_toolbox/752915090f46dff7eaf98392871883106546a1b9/package.xml');


--After you can connect to T-SQL>master and exec this:
--You can't store and select json type objects from T-SQL,
select * from
	json_each_text(get_json('https://raw.githubusercontent.com/monkvision/monkjs/181105c64feefbca06a21a3b4021972a560d9f62/packages/sights/package.json'));
select * from 
	get_xml('https://raw.githubusercontent.com/mgaoling/mpl_dataset_toolbox/752915090f46dff7eaf98392871883106546a1b9/package.xml');