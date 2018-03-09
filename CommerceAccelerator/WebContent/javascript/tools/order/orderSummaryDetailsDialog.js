//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*

  function printAction()
  {
    self.CONTENTS.window.focus();
    self.CONTENTS.printAction();
  }

  function emailOrder()
  {
    self.CONTENTS.emailOrder();
  }

  function closeAction()
  {
    top.goBack();
  }


