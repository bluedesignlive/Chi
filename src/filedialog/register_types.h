#pragma once

class QQmlEngine;

void registerFileDialogTypes(const char *uri);
void initializeFileDialogEngine(QQmlEngine *engine);
