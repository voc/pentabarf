<?php

require_once('../classes/database/db_base.php');
require_once('../classes/database/datatypes/dt_integer.php');
require_once('../classes/database/datatypes/dt_timestamp.php');
require_once('../classes/database/datatypes/dt_bool.php');

/// class for accessing and manipulating content of table person_transaction
class PERSON_TRANSACTION extends DB_BASE
{
   /// constructor of the class person_transaction
   public function __construct()
   {
      parent::__construct();
      $this->table = 'person_transaction';
      $this->domain = 'person_transaction';
      $this->limit = 0;
      $this->order = '';

      $this->fields['changed_by'] = new DT_INTEGER( $this, 'changed_by', array(), array('NOT_NULL' => true) );
      $this->fields['f_create'] = new DT_BOOL( $this, 'f_create', array(), array('DEFAULT' => true, 'NOT_NULL' => true) );
      $this->fields['changed_when'] = new DT_TIMESTAMP( $this, 'changed_when', array(), array('DEFAULT' => true, 'NOT_NULL' => true, 'PRIMARY_KEY' => true) );
      $this->fields['person_id'] = new DT_INTEGER( $this, 'person_id', array(), array('NOT_NULL' => true, 'PRIMARY_KEY' => true) );
   }

}

?>
