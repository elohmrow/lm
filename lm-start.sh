# [1] make the directory structure for a basic light module
LMDIR=$1

mkdir $LMDIR

mkdir -p $LMDIR/dialogs/components 
mkdir -p $LMDIR/dialogs/pages 

mkdir -p $LMDIR/templates/areas 
mkdir -p $LMDIR/templates/components 
mkdir -p $LMDIR/templates/pages 

mkdir -p $LMDIR/webresources/css
mkdir -p $LMDIR/webresources/js

cp /Users/bandersen/DEMO/light-modules/bootstrap.css $LMDIR/webresources/css/
cp /Users/bandersen/DEMO/light-modules/bootstrap.js $LMDIR/webresources/js/

# ###########################################################################################
# add some JS models stuff
#
cat <<EOT>> $LMDIR/templates/pages/rhino.yaml
templateScript: /$LMDIR/templates/pages/rhino.ftl
renderType: freemarker
modelClass: info.magnolia.module.jsmodels.rendering.JavascriptRenderingModel
EOT

cat <<EOT>> $LMDIR/templates/pages/rhino.ftl
<div>Hey \${model.name}, your happiness level is at \${model.getRandomNumber()}%.</div>
EOT

cat <<EOT>> $LMDIR/templates/pages/rhino.js
var Dumbo = function () {
    this.name = "Lance";
    this.getRandomNumber = function () {
        return Math.ceil(100 * Math.random());
    }
};
new Dumbo();
EOT
#
# end some JS models stuff
# ###########################################################################################


# [2] add a page template
cat <<EOT >> $LMDIR/templates/pages/first.yaml
renderType: freemarker
title: First FTL
templateScript: /$LMDIR/templates/pages/first.ftl
dialog: $LMDIR:firstFTL
areas:
  main:
    availableComponents:
      textImage:
        id: $LMDIR:components/textImage
      twoColumns:
        id: $LMDIR:components/twoColumns
EOT

# [3] add a page template script
cat <<EOT >> $LMDIR/templates/pages/first.ftl
<!DOCTYPE html>
<html xml:lang="en" lang="en" class="no-js">
    <head>
        [@cms.page /]
        
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <link rel="stylesheet" href="\${ctx.contextPath}/.resources/$LMDIR/webresources/css/bootstrap.css" media="screen">
    </head>
    <body>
        <div class="container">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">\${content.title!"Hello World - Page"}</h3>
                </div>
                <div class="panel-body">
                    <p>\${content.abstract!"This will become the page's abstract."}</p>
                </div>
            </div> 
            [#-- ****** main area ****** --]
            <!-- ADD AREA TAG HERE -->
            [@cms.area name="main" /]
        </div>
    </body>
</html>
EOT

# [4] add the components refered to in the page template
cat <<EOT >> $LMDIR/templates/components/textImage.yaml
dialog: $LMDIR:textImage
description: Enter text and image content
renderType: freemarker
title: Text & Image
templateScript: /$LMDIR/templates/components/textImage.ftl
EOT

cat <<EOT >> $LMDIR/templates/components/twoColumns.yaml
dialog: $LMDIR:twoColumns
description: add components into two columns
renderType: freemarker
title: Two Columns
templateScript: /$LMDIR/templates/components/twoColumns.ftl
areas:
  leftColumn:
    availableComponents:
      textImage:
        id: $LMDIR:components/textImage
      twoColumns:
        id: $LMDIR:components/twoColumns
  rightColumn:
    availableComponents:
      textImage:
        id: $LMDIR:components/textImage
      twoColumns:
        id: $LMDIR:components/twoColumns
parameters:
  divColLeft: col-sm-8
  divColRight: col-sm-4
EOT

# [5] add the component scripts for those components
cat <<EOT >> $LMDIR/templates/components/textImage.ftl
<div class="\${def.parameters.divClass!"default-text-image"}">
    \${cmsfn.decode(content).text!}
     
    [#if  content.image?has_content]
        <img alt="Using cmsfn object." src="\${cmsfn.link(content.image)}">
    [/#if]
     
</div>
EOT

cat <<EOT >> $LMDIR/templates/components/twoColumns.ftl
<div class="row">
    <div class="\${def.parameters.divColLeft!"col-sm-6"}"">
        <div class="panel panel-default">
            <div class="panel-heading">\${content.titleLeft!}</div>
            <div class="panel-body">
                [@cms.area name="leftColumn" /]
            </div>
        </div>
    </div>
    <div class="\${def.parameters.divColRight!"col-sm-6"}">
        <div class="panel panel-default">
            <div class="panel-heading">\${content.titleRight!}</div>
            <div class="panel-body">
                [@cms.area name="rightColumn" /]
            </div>
        </div>
    </div>    
</div>
EOT

# [6] add the dialogs
cat <<EOT >> $LMDIR/dialogs/firstFTL.yaml
actions:
  commit:
    label: save changes
    class: info.magnolia.ui.admincentral.dialog.action.SaveDialogActionDefinition
  cancel:
    label: cancel
    class: info.magnolia.ui.admincentral.dialog.action.CancelDialogActionDefinition
form:
  tabs:
    - name: tabMain
      label: First Page Dialog
      fields:
        - name: title
          description: enter the page title
          label: title
          required: true
          class: info.magnolia.ui.form.field.definition.TextFieldDefinition
        - name: abstract
          label: abstract
          description: enter an abstract
          rows: 5
          class: info.magnolia.ui.form.field.definition.TextFieldDefinition
EOT

cat <<EOT >> $LMDIR/dialogs/textImage.yaml
actions:
  commit:
    label: save changes
    class: info.magnolia.ui.admincentral.dialog.action.SaveDialogActionDefinition
  cancel:
    label: cancel
    class: info.magnolia.ui.admincentral.dialog.action.CancelDialogActionDefinition
form:
  tabs:
    - name: tabMain
      label: Text & Image Dialog
      fields:
        - name: text
          label: text
          description: enter some text
          class: info.magnolia.ui.form.field.definition.TextFieldDefinition
        - name: image
          binaryNodeName: image
          label: image
          description: upload an image
          class: info.magnolia.ui.form.field.definition.BasicUploadFieldDefinition
    - name: secondTab
      label: Text & Image Dialog
      fields:
        - name: text
          label: text
          description: enter some text
          class: info.magnolia.ui.form.field.definition.TextFieldDefinition
        - name: image
          binaryNodeName: image
          label: image
          description: upload an image
          class: info.magnolia.ui.form.field.definition.BasicUploadFieldDefinition
EOT

cat <<EOT >> $LMDIR/dialogs/twoColumns.yaml
actions:
  commit:
    label: save changes
    class: info.magnolia.ui.admincentral.dialog.action.SaveDialogActionDefinition
  cancel:
    label: cancel
    class: info.magnolia.ui.admincentral.dialog.action.CancelDialogActionDefinition
form:
  tabs:
    - name: tabMain
      label: Two Columns dialog
      fields:
        - name: titleLeft
          label: left title
          description: enter the left title
          class: info.magnolia.ui.form.field.definition.TextFieldDefinition
        - name: titleRight
          label: right title
          description: enter the right title
          class: info.magnolia.ui.form.field.definition.TextFieldDefinition
EOT
