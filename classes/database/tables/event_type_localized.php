<?php

require_once('../classes/database/db_base.php');
require_once('../classes/database/datatypes/dt_varchar.php');
require_once('../classes/database/datatypes/dt_integer.php');

/// class for accessing and manipulating content of table event_type_localized
class EVENT_TYPE_LOCALIZED extends DB_BASE
{
   /// constructor of the class event_type_localized
   public function __construct()
   {
      parent::__construct();
      $this->table = 'event_type_localized';
      $this->domain = 'event_type_localized';
      $this->limit = 0;
      $this->order = '';

      $this->fields['name'] = new DT_VARCHAR( $this, 'name', array('length' => 64), array('NOT_NULL' => true) );
      $this->fields['event_type_id'] = new DT_INTEGER( $this, 'event_type_id', array(), array('NOT_NULL' => true, 'PRIMARY_KEY' => true) );
      $this->fields['language_id'] = new DT_INTEGER( $this, 'language_id', array(), array('NOT_NULL' => true, 'PRIMARY_KEY' => true) );
   }

}

?>
