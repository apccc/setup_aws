<?php

$user=loginModel::requireAdmin();

$database=$SITE_DATABASE;
$table="navigation";
$single_name="Navigation Control";
$multiple_name=$single_name."s";
$list_fields=array(
	'site_id','name','identifier'
);
$search_fields=array(
	'name','identifier','href','content'
);
$edit_fields=array(
	'parent'=>array(
		'field_name'=>'parent',
		'blank_top_select'=>false,
		'input_value'=>'id',
		'input_visible'=>'name',
		'select_db'=>$database,
		'select_table'=>$table,
		'select_table_where'=>"WHERE `active`='T' ORDER BY `name` ASC",
		'edit_field_type'=>'select'
	),
	'name'=>array(),
	'identifier'=>array(
		'attr.pattern'=>"^[a-z0-9_-]+$",
		'attr.class'=>"validate",
		'attr.required'=>"required"
	),
	'description'=>array(
		'edit_field_type'=>'textarea'
	),
	'href'=>array(),
	'content'=>array(
		'edit_field_type'=>'textarea'
	),
	'active'=>array(
		'edit_field_type'=>'t_or_f'
	)
);

require_once dirname(__FILE__)."/template.php";
$admin_class=new admin_doc_class;
?>